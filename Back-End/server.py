from flask import Flask, request, jsonify
import boto3
from boto3.dynamodb.conditions import Attr
# Route that returns the 'word' parameter
# Initialize DynamoDB resource with a specific region
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Name of your DynamoDB table
table_name = "tweet-politics"

app = Flask(__name__)

@app.route('/raw', methods=['GET'])
def raw_route():
    word = request.args.get('word')  # Get the 'word' parameter
    if not word:
        return jsonify({"error": "The 'word' parameter is required"}), 400

    try:
        # Access the DynamoDB table
        table = dynamodb.Table(table_name)

        # Perform a scan with a filter condition based on 'word'
        response = table.scan(
            FilterExpression=Attr('text').contains(word)
        )

        # Get the items from the response
        items = response.get('Items', [])

        # Return the items in JSON format
        return jsonify({"results": items}), 200

    except Exception as e:
        # Return an error message if something goes wrong
        return jsonify({"error": str(e)}), 500


# Route that returns the 'username' parameter
@app.route('/user', methods=['GET'])
def user_route():
    username = request.args.get('username')  # Get the 'username' parameter
    if not username:
        return jsonify({"error": "The 'username' parameter is required"}), 400

    try:
        # Access the DynamoDB table
        table = dynamodb.Table(table_name)

        # Perform a scan with a filter condition based on 'username'
        response = table.scan(
            FilterExpression=Attr('user').eq(username)
        )

        # Get the items from the response
        items = response.get('Items', [])

        # Return the items in JSON format
        return jsonify({"results": items}), 200

    except Exception as e:
        # Return an error message if something goes wrong
        return jsonify({"error": str(e)}), 500

# Route that performs a basic analysis on the 'word' parameter
@app.route('/analysis', methods=['GET'])
def analysis_route():
    word = request.args.get('word')  # Get the 'word' parameter
    if word:
        # Simple analysis on the word (in this case, just its length)
        analysis_result = {"length": len(word)}
        return jsonify({"analysis": analysis_result})
    else:
        return jsonify({"error": "The 'word' parameter is required"}), 400

# Start the Flask server
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)  # Change the port if needed