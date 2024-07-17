import csv
import boto3
import uuid

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table_name = 'tweets-raw'
table = dynamodb.Table(table_name)


# Define a function to read CSV and insert data into DynamoDB
def insert_data_from_csv(csv_file_path):
    try:
        with open(csv_file_path, mode='r', encoding='utf-8') as csv_file:
            csv_reader = csv.DictReader(csv_file)
            for row in csv_reader:
                # Generate a unique ID for each tweet
                tweet_id = str(uuid.uuid4())

                # Extract data from CSV row
                subject = row['subject']
                user = row['user']
                text = row['text']

                # Insert data into DynamoDB
                table.put_item(
                    Item={
                        'id': tweet_id,
                        'subject': subject,
                        'user': user,
                        'text': text
                    }
                )
        print("Data inserted successfully!")
    except KeyError as e:
        print(f"Missing key: {str(e)} in CSV file")
    except Exception as e:
        print(f"An error occurred: {str(e)}")


# Path to your CSV file
csv_file_path = 'random_tweets.csv'

# Call the function to insert data
insert_data_from_csv(csv_file_path)