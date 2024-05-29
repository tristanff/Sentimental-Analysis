data "archive_file" "tweets_raw" {
  type        = "zip"
  source_file = "../lambdas/tweets_raw.py"
  output_path = "../lambdas/tweets_raw.zip"
}
resource "aws_lambda_function" "tweets_raw" {
  filename      = "../lambdas/tweets_raw.zip"
  function_name = "tweets_raw"
  role          = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler       = "tweets_raw.lambda_handler"
  runtime       = "python3.8"
}

data "archive_file" "consult_db" {
  type        = "zip"
  source_file = "../lambdas/consult_db.py"
  output_path = "../lambdas/consult_db.zip"
}
resource "aws_lambda_function" "consult_db" {
  filename      = "../lambdas/consult_db.zip"
  function_name = "consult_db"
  role          = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler       = "consult_db.lambda_handler"
  runtime       = "python3.8"
}

data "archive_file" "add_tweet" {
  type        = "zip"
  source_file = "../lambdas/add_tweet.py"
  output_path = "../lambdas/add_tweet.zip"
}
resource "aws_lambda_function" "add_tweet" {
  filename      = "../lambdas/add_tweet.zip"
  function_name = "add_tweet"
  role          = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler       = "add_tweet.lambda_handler"
  runtime       = "python3.8"
}

data "archive_file" "update_db" {
  type        = "zip"
  source_file = "../lambdas/update_db.py"
  output_path = "../lambdas/update_db.zip"
}
resource "aws_lambda_function" "update_db" {
  filename      = "../lambdas/update_db.zip"
  function_name = "update_db"
  role          = "arn:aws:iam::${var.account_id}:role/LabRole"
  handler       = "update_db.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_api_gateway_rest_api" "sentimental_api" {
  name = "sentimental-analysis-api-gw"
}

# GET /tweets_raw endpoint
resource "aws_api_gateway_resource" "tweets_raw" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "tweets_raw"
}
resource "aws_api_gateway_method" "tweets_raw" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.tweets_raw.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "tweets_raw" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.tweets_raw.id
  http_method             = aws_api_gateway_method.tweets_raw.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.tweets_raw.invoke_arn
}
resource "aws_lambda_permission" "tweets_raw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tweets_raw.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.sentimental_api.id}/*/${aws_api_gateway_method.tweets_raw.http_method}${aws_api_gateway_resource.tweets_raw.path}"
}

# GET /consult_db endpoint
resource "aws_api_gateway_resource" "consult_db" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "consult_db"
}
resource "aws_api_gateway_method" "consult_db" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.consult_db.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "consult_db" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.consult_db.id
  http_method             = aws_api_gateway_method.consult_db.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.consult_db.invoke_arn
}
resource "aws_lambda_permission" "consult_db" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consult_db.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.sentimental_api.id}/*/${aws_api_gateway_method.consult_db.http_method}${aws_api_gateway_resource.consult_db.path}"
}

# POST /add_tweet endpoint
resource "aws_api_gateway_resource" "add_tweet" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "add_tweet"
}
resource "aws_api_gateway_method" "add_tweet" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.add_tweet.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "add_tweet" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.add_tweet.id
  http_method             = aws_api_gateway_method.add_tweet.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.add_tweet.invoke_arn
}
resource "aws_lambda_permission" "add_tweet" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_tweet.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.sentimental_api.id}/*/${aws_api_gateway_method.add_tweet.http_method}${aws_api_gateway_resource.add_tweet.path}"
}

# POST /update_db endpoint
resource "aws_api_gateway_resource" "update_db" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  parent_id   = aws_api_gateway_rest_api.sentimental_api.root_resource_id
  path_part   = "update_db"
}
resource "aws_api_gateway_method" "update_db" {
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  resource_id   = aws_api_gateway_resource.update_db.id
  http_method   = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "update_db" {
  rest_api_id             = aws_api_gateway_rest_api.sentimental_api.id
  resource_id             = aws_api_gateway_resource.update_db.id
  http_method             = aws_api_gateway_method.update_db.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.update_db.invoke_arn
}
resource "aws_lambda_permission" "update_db" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_db.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.sentimental_api.id}/*/${aws_api_gateway_method.update_db.http_method}${aws_api_gateway_resource.update_db.path}"
}


resource "aws_api_gateway_deployment" "sentimental_api" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id
  # triggers = {
  #   redeployment = sha1(jsonencode(aws_api_gateway_rest_api.sentimental_api.body))
  # }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.tweets_raw, aws_api_gateway_integration.tweets_raw, 
    aws_api_gateway_method.consult_db, aws_api_gateway_integration.consult_db, 
    aws_api_gateway_method.add_tweet, aws_api_gateway_integration.add_tweet, 
    aws_api_gateway_method.update_db, aws_api_gateway_integration.update_db]
}

resource "aws_api_gateway_stage" "sentimental_api" {
  deployment_id = aws_api_gateway_deployment.sentimental_api.id
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  stage_name    = "prod"
}