import json
import boto3
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource('dynamodb')
table_name = 'tweets-processed'


def lambda_handler(event, context):
    try:
        # Analyse du contenu JSON du champ 'body'
        body = json.loads(event['body'])

        # Accéder à la clé 'word' dans le corps JSON
        word = body['word']

        if not word:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "The 'word' parameter is required"})
            }

        # Access the DynamoDB table
        table = dynamodb.Table(table_name)

        # Perform a scan with a filter condition based on 'word'
        response = table.scan(
            FilterExpression=Attr('text').contains(word)
        )

        # Get the items from the response
        items = response.get('Items', [])

        # Return the items in JSON format
        return {
            "statusCode": 200,
            "body": json.dumps({"results": items})
        }
    except KeyError as e:
        # Handle KeyError if 'word' key is missing
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing 'word' key in request body"})
        }
    except Exception as e:
        # Return an error message if something goes wrong
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
