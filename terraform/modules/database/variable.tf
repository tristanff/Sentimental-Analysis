variable "table_names" {
  description = "Name of the DynamoDB tables"
  type        = list(string)
  default     = ["tweets-raw", "tweets-processed"]
}
variable "db_billing_mode" {
  description = "Billing mode for the Dynamo database"
  type        = string
  default     = "PAY_PER_REQUEST"
}