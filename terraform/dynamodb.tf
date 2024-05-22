# DynamoDB tables
resource "aws_dynamodb_table" "tweets_raw" {
  name           = "tweets-raw"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  range_key      = "subject"  # Sort key
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "subject"
    type = "S"
  }
  attribute {
    name = "user"
    type = "S"
  }
  attribute {
    name = "text"
    type = "S"
  }
}


resource "aws_dynamodb_table" "tweets_processed" {
  name           = "tweets-processed"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  range_key      = "subject"  # Sort key
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "subject"
    type = "S"
  }
  attribute {
    name = "user"
    type = "S"
  }
  attribute {
    name = "text"
    type = "S"
  }
  attribute {
    name = "sentiment"
    type = "S"
  }
}
