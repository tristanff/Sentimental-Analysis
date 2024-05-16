import json
import boto3

dynamodb = boto3.resource('dynamodb')
source_table_name = 'tweets-raw'
destination_table_name = 'tweets-processed'


def lambda_handler(event, context):
    try:
        # Access the source table
        source_table = dynamodb.Table(source_table_name)

        # Check if the event contains a body
        if 'body' not in event:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Event body is empty"})
            }

        # Parse the body as JSON
        body = json.loads(event['body'])

        # Check if the body contains tweets
        if not body:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "No tweets found in the request body"})
            }

        # Access the list of tweets from the body
        tweets = body

        # Delete each item from the source table
        for tweet in tweets:
            # Construct the key including both the partition key ('id') and the sort key ('subject')
            key = {'id': tweet['id'], 'subject': tweet['subject']}
            source_table.delete_item(Key=key)

        # Access the destination table
        destination_table = dynamodb.Table(destination_table_name)

        # Add each tweet to the destination table
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
