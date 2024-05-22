# lambdas.tf

# Lambda function for getRawTweets
resource "aws_lambda_function" "get_raw_tweets" {
  function_name    = "getRawTweets"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = "arn:aws:iam::058264505049:role/LabRole"
  memory_size      = 128  # Adjust memory size as needed
  timeout          = 3    # Adjust timeout as needed
  # Add other optional parameters if needed
}

# Lambda function for consult-db
resource "aws_lambda_function" "consult_db" {
  function_name    = "consult-db"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = "arn:aws:iam::058264505049:role/LabRole"
  memory_size      = 128  # Adjust memory size as needed
  timeout          = 3    # Adjust timeout as needed
  # Add other optional parameters if needed
}

# Lambda function for update-Dbs
resource "aws_lambda_function" "update_dbs" {
  function_name    = "update-Dbs"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = "arn:aws:iam::058264505049:role/LabRole"
  memory_size      = 128  # Adjust memory size as needed
  timeout          = 3    # Adjust timeout as needed
  # Add other optional parameters if needed
}

# Lambda function for addTweetDynamo
resource "aws_lambda_function" "add_tweet_dynamo" {
  function_name    = "addTweetDynamo"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  role             = "arn:aws:iam::058264505049:role/LabRole"
  memory_size      = 128  # Adjust memory size as needed
  timeout          = 3    # Adjust timeout as needed
  # Add other optional parameters if needed
}
