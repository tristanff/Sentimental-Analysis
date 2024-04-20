from flask import Flask, jsonify
import boto3
from boto3.dynamodb.conditions import Attr
import json

# Initialize Flask application
app = Flask(__name__)

# Initialize DynamoDB resource with a specific region
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Name of your DynamoDB table
table_name = "tweet-politics"

# Create a context for the Flask application
with app.app_context():
    # Access the DynamoDB table
    table = dynamodb.Table(table_name)

    # Perform a scan with a filter condition
    response = table.scan(
        FilterExpression=Attr('text').contains("ukraine")
    )

    # Get the items from the response
    items = response.get('Items', [])

    # Use jsonify to create a Flask response
    flask_response = jsonify({"items": items})

    # Convert Flask response to JSON-friendly dictionary
    response_json = flask_response.get_json()

    # Display the JSON response in a formatted manner
    formatted_response = json.dumps(response_json, indent=4)
    print(formatted_response)
