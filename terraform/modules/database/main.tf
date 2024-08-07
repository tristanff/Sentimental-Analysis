module "dynamodb_table" {
  source       = "terraform-aws-modules/dynamodb-table/aws"
  for_each     = toset(var.table_names)
  name         = each.key
  billing_mode = var.db_billing_mode
  hash_key     = "subject"
  range_key    = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "subject"
      type = "S"
    }
  ]
}