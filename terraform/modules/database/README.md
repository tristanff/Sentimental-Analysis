<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_billing_mode"></a> [db\_billing\_mode](#input\_db\_billing\_mode) | Billing mode for the Dynamo database | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_table_names"></a> [table\_names](#input\_table\_names) | Name of the DynamoDB tables | `list(string)` | <pre>[<br>  "tweets-raw",<br>  "tweets-processed"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->