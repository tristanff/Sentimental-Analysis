resource "aws_api_gateway_rest_api" "sentimental_api" {
  name        = "sentimentalAnalysis-API"
  description = "API for sentimental analysis"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = 1024
}

resource "aws_api_gateway_resource" "consult_db_resource" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "consult-db"
}

resource "aws_api_gateway_resource" "tweets_raw_resource" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "tweets_raw"
}

resource "aws_api_gateway_resource" "add_tweet_resource" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "add_tweet"
}

resource "aws_api_gateway_resource" "update_db_resource" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "update_db"
}

resource "aws_api_gateway_method" "consult_db_method" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.consult_db_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "tweets_raw_method" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.tweets_raw_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "add_tweet_method" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.add_tweet_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "update_db_method" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.update_db_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "consult_db_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.consult_db_resource.id
  http_method             = aws_api_gateway_method.consult_db_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "aws_lambda_function.tweets_raw_lambda.invoke_arn"
}

resource "aws_api_gateway_integration" "tweets_raw_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.tweets_raw_resource.id
  http_method             = aws_api_gateway_method.tweets_raw_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "aws_lambda_function.tweets_raw_lambda.invoke_arn"
}

resource "aws_api_gateway_integration" "add_tweet_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.add_tweet_resource.id
  http_method             = aws_api_gateway_method.add_tweet_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "aws_lambda_function.add_tweet_lambda.invoke_arn"
}

resource "aws_api_gateway_integration" "update_db_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.update_db_resource.id
  http_method             = aws_api_gateway_method.update_db_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "aws_lambda_function.consult_db_lambda.invoke_arn"
}

resource "aws_lambda_function" "consult_db_lambda" {
  filename         = "../lambdas/get_tweets_from_word.py"
  function_name    = "get_tweets_from_word"
  role             = aws_iam_role.lab_role.arn
  handler          = "consult-db.handler"
  runtime          = "python3.8"
}

resource "aws_lambda_function" "tweets_raw_lambda" {
  filename         = "../lambdas/get_tweets_raw.py"
  function_name    = "tweets-raw-lambda"
  role             = aws_iam_role.lab_role.arn
  handler          = "tweets-raw.handler"
  runtime          = "python3.8"
}

resource "aws_lambda_function" "add_tweet_lambda" {
  filename         = "../lambdas/add_tweet.py"
  function_name    = "add-tweet-lambda"
  role             = aws_iam_role.lab_role.arn
  handler          = "add-tweet.handler"
  runtime          = "python3.8"
}

resource "aws_lambda_function" "update_db_lambda" {
  filename         = "../lambdas/update-db.py"
  function_name    = "update-db-lambda"
  role             = aws_iam_role.lab_role.arn
  handler          = "update-db.handler"
  runtime          = "python3.8"
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.sentimental_api.id
}

output "api_gateway_url" {
  value = aws_api_gateway_rest_api.sentimental_api.root_resource_id
}

output "consult_db_resource_id" {
  value = aws_api_gateway_resource.consult_db_resource.id
}

output "tweets_raw_resource_id" {
  value = aws_api_gateway_resource.tweets_raw_resource.id
}

output "add_tweet_resource_id" {
  value = aws_api_gateway_resource.add_tweet_resource.id
}

output "update_db_resource_id" {
  value = aws_api_gateway_resource.update_db_resource.id
}

