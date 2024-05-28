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
  path_part   = "consult_db"
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

data "archive_file" "consult_db_lambda" {
  type        = "zip"
  source_file = "../lambdas/consult_db.py"
  output_path = "../lambdas/consult_db.zip"
}

data "archive_file" "tweets_raw_lambda" {
  type        = "zip"
  source_file = "../lambdas/tweets_raw.py"
  output_path = "../lambdas/tweets_raw.zip"
}


data "archive_file" "add_tweet_lambda" {
  type        = "zip"
  source_file = "../lambdas/add_tweet.py"
  output_path = "../lambdas/add_tweet.zip"
}

data "archive_file" "update_db_lambda" {
  type        = "zip"
  source_file = "../lambdas/update_db.py"
  output_path = "../lambdas/update_db.zip"
}


resource "aws_api_gateway_integration" "consult_db_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.consult_db_resource.id
  http_method             = aws_api_gateway_method.consult_db_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.consult_db_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "tweets_raw_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.tweets_raw_resource.id
  http_method             = aws_api_gateway_method.tweets_raw_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.tweets_raw_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "add_tweet_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.add_tweet_resource.id
  http_method             = aws_api_gateway_method.add_tweet_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.add_tweet_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "update_db_integration" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.update_db_resource.id
  http_method             = aws_api_gateway_method.update_db_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.update_db_lambda.invoke_arn
}

resource "aws_lambda_function" "consult_db_lambda" {
  filename      = "../lambdas/consult_db.zip"
  function_name = "consult_db"
  role          = var.lab_role_arn
  handler       = "consult_db.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "tweets_raw_lambda" {
  filename      = "../lambdas/tweets_raw.zip"
  function_name = "tweets_raw"
  role          = var.lab_role_arn
  handler       = "tweets_raw.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "add_tweet_lambda" {
  filename      = "../lambdas/add_tweet.zip"
  function_name = "add_tweet"
  role          = var.lab_role_arn
  handler       = "add_tweet.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function" "update_db_lambda" {
  filename      = "../lambdas/update_db.zip"
  function_name = "update_db"
  role          = var.lab_role_arn
  handler       = "update_db.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_api_gateway_deployment" "sentimental_api_deployment" {
  depends_on  = [aws_api_gateway_rest_api.sentimental_api, aws_api_gateway_integration.add_tweet_integration, aws_api_gateway_integration.consult_db_integration, aws_api_gateway_integration.tweets_raw_integration, aws_api_gateway_integration.update_db_integration]
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  stage_name  = "prod" # Nom de votre stage
}

resource "aws_lambda_permission" "consult_db_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consult_db_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.sentimental_api.execution_arn}/*/GET/consult_db"
}

resource "aws_lambda_permission" "tweets_raw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tweets_raw_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.sentimental_api.execution_arn}/*/GET/tweets_raw"
}

resource "aws_lambda_permission" "add_tweet_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_tweet_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.sentimental_api.execution_arn}/*/POST/add_tweet"
}

resource "aws_lambda_permission" "update_db_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_db_lambda.arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.sentimental_api.execution_arn}/*/POST/update_db"
}

