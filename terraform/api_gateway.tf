# API Gateway
resource "aws_api_gateway_rest_api" "sentimental_api" {
  name        = "sentimentalAnalysis-API"
  description = "API for sentimental analysis"
  body = jsonencode({
    openapi = "3.0.1",
    info = {
      title    = "sentimentalAnalysis-API"
      version  = "2024-05-16 20:30:24UTC"
    },
    servers = [{
      url = "https://95w8sc9vl2.execute-api.us-east-1.amazonaws.com/{basePath}"
      variables = {
        basePath = {
          default = ""
        }
      }
    }],
    paths = {
      "/consult-db" = {
        get = {
          responses = {
            default = {
              description = "Default response for GET /consult-db"
            }
          }
          "x-amazon-apigateway-integration" = {
            payloadFormatVersion = "2.0"
            type                 = "aws_proxy"
            httpMethod           = "POST"
            uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:058264505049:function:consult-db/invocations"
            connectionType       = "INTERNET"
          }
        }
      },
      "/tweets_raw" = {
        get = {
          responses = {
            default = {
              description = "Default response for GET /tweets_raw"
            }
          }
          "x-amazon-apigateway-integration" = {
            payloadFormatVersion = "2.0"
            type                 = "aws_proxy"
            httpMethod           = "POST"
            uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:058264505049:function:getRawTweets/invocations"
            connectionType       = "INTERNET"
          }
        }
      },
      "/add_tweet" = {
        post = {
          responses = {
            default = {
              description = "Default response for POST /add_tweet"
            }
          }
          "x-amazon-apigateway-integration" = {
            payloadFormatVersion = "2.0"
            type                 = "aws_proxy"
            httpMethod           = "POST"
            uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:058264505049:function:addTweetDynamo/invocations"
            connectionType       = "INTERNET"
          }
        }
      },
      "/update_db" = {
        post = {
          responses = {
            default = {
              description = "Default response for POST /update_db"
            }
          }
          "x-amazon-apigateway-integration" = {
            payloadFormatVersion = "2.0"
            type                 = "aws_proxy"
            httpMethod           = "POST"
            uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:058264505049:function:update-Dbs/invocations"
            connectionType       = "INTERNET"
          }
        }
      }
    },
    components = {
      "x-amazon-apigateway-integrations" = {
        unusedIntegration_ugyke9r = {
          payloadFormatVersion = "2.0"
          type                 = "aws_proxy"
          httpMethod           = "POST"
          uri                  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:058264505049:function:getRawTweets/invocations"
          connectionType       = "INTERNET"
        }
      }
    },
    "x-amazon-apigateway-importexport-version" = "1.0"
  })
}
