resource "aws_cognito_user_pool" "user_pool" {
  name = "sa-pool"
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = "client"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  callback_urls                        = ["https://localhost"]
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "sentimental-analysis2"
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}" #aws_cognito_user_pool.user_pool.id
}


# tweets_raw lambda
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
  vpc_config {
    subnet_ids         = [var.private_subnet_id]
    security_group_ids = [var.lambda_sg]
  }
}
# consult_db lambda
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
  vpc_config {
    subnet_ids         = [var.private_subnet_id]
    security_group_ids = [var.lambda_sg]
  }
}

# add_tweet lambda
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
  vpc_config {
    subnet_ids         = [var.private_subnet_id]
    security_group_ids = [var.lambda_sg]
  }
}

# update_db lambda
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
  vpc_config {
    subnet_ids         = [var.private_subnet_id]
    security_group_ids = [var.lambda_sg]
  }
}

# API definition
resource "aws_api_gateway_rest_api" "sentimental_api" {
  name = "sentimental-analysis-api-gw"
}

# Authorizer
resource "aws_api_gateway_authorizer" "api_authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  provider_arns = [aws_cognito_user_pool.user_pool.arn]
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
  depends_on    = [aws_api_gateway_resource.tweets_raw]
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
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id
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
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id
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

# Deployment definition
resource "aws_api_gateway_deployment" "sentimental_api" {
  rest_api_id = aws_api_gateway_rest_api.sentimental_api.id

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.tweets_raw, aws_api_gateway_integration.tweets_raw,
    aws_api_gateway_method.consult_db, aws_api_gateway_integration.consult_db,
    aws_api_gateway_method.add_tweet, aws_api_gateway_integration.add_tweet,
    aws_api_gateway_method.update_db, aws_api_gateway_integration.update_db
  ]
}

resource "aws_api_gateway_stage" "sentimental_api" {
  deployment_id = aws_api_gateway_deployment.sentimental_api.id
  rest_api_id   = aws_api_gateway_rest_api.sentimental_api.id
  stage_name    = "prod"
}