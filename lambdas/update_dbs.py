import json
import boto3

dynamodb = boto3.resource('dynamodb')
source_table_name = 'tweets-raw'
destination_table_name = 'tweets-processed'

def lambda_handler(event, context):
    try:
        # Check if the list of tweets is provided in the event
        if 'tweets' not in event:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing 'tweets' key in the event payload"})
            }

        # Access the list of tweets in the event
        tweets = event['tweets']

        # Access the source table and delete all items
        source_table = dynamodb.Table(source_table_name)
        source_table.delete()

        # Access the destination table
        destination_table = dynamodb.Table(destination_table_name)

        # Iterate through all tweets and add them to the destination table
        for tweet in tweets:
            destination_table.put_item(Item=tweet)

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Tweets added to the destination table"})
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
