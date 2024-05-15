import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table_name = 'tweets-raw'

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])

        tweet_id = str(uuid.uuid4())

        user = body.get('user')
        text = body.get('text')
        subject = body.get('subject')


        if not (user and text and subject):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing required fields: 'user', 'text', or 'subject'"})
            }

        table = dynamodb.Table(table_name)

        table.put_item(
            Item={
                'id': tweet_id,
                'subject': subject,
                'user': user,
                'text': text
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Tweet added successfully", "tweet_id": tweet_id})
        }
    except KeyError as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": f"Missing key: {str(e)} in request body"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
