import json
import boto3
from boto3.dynamodb.conditions import Key, Attr

dynamodb = boto3.resource('dynamodb')
table_name = 'tweets-processed'

def lambda_handler(event, context):
    try:
        query_parameters = event.get('queryStringParameters', {})
        subject = query_parameters.get('subject')
        id_value = query_parameters.get('id')
        user = query_parameters.get('user')
        text = query_parameters.get('text')

        table = dynamodb.Table(table_name)

        # Determine the appropriate query method based on the provided parameters
        if subject and id_value:
            # Query by subject and id (assuming subject is the partition key and id is the sort key)
            response = table.query(
                KeyConditionExpression=Key('subject').eq(subject) & Key('id').eq(id_value)
            )
            items = response.get('Items', [])
        elif subject:
            # Query by subject only (assuming subject is the partition key)
            response = table.query(
                KeyConditionExpression=Key('subject').eq(subject)
            )
            items = response.get('Items', [])
        elif user:
            # Scan by user attribute
            response = table.scan(
                FilterExpression=Attr('user').eq(user)
            )
            items = response.get('Items', [])
        elif text:
            # Scan by text attribute
            response = table.scan(
                FilterExpression=Attr('text').contains(text)
            )
            items = response.get('Items', [])
        else:
            # No specific query parameter provided
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "At least one query parameter must be provided"})
            }

        # Filter items by all specified attributes if more than one attribute is provided
        if len(query_parameters) > 1:
            filtered_items = items
            if id_value:
                filtered_items = [item for item in filtered_items if item.get('id') == id_value]
            if user:
                filtered_items = [item for item in filtered_items if item.get('user') == user]
            if text:
                filtered_items = [item for item in filtered_items if text in item.get('text', '')]
        else:
            filtered_items = items

        return {
            "statusCode": 200,
            "body": json.dumps({"results": filtered_items})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }