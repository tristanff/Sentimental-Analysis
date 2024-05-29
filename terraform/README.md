<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.49.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application"></a> [application](#module\_application) | ./modules/application | n/a |
| <a name="module_compute"></a> [compute](#module\_compute) | ./modules/compute | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for all resources | `string` | `"us-east-1"` | no |
| <a name="input_container_image_url"></a> [container\_image\_url](#input\_container\_image\_url) | The url of the compute containter image | `string` | `""` | no |
| <a name="input_db_billing_mode"></a> [db\_billing\_mode](#input\_db\_billing\_mode) | Billing mode for the Dynamo database | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_lab_role_arn"></a> [lab\_role\_arn](#input\_lab\_role\_arn) | ARN of your lab role | `string` | `""` | no |
| <a name="input_public_az"></a> [public\_az](#input\_public\_az) | Name of the public availability zone | `string` | `"us-east-1a"` | no |
| <a name="input_public_cidr"></a> [public\_cidr](#input\_public\_cidr) | CIDR of the public subnet | `string` | `"10.0.1.0/24"` | no |
| <a name="input_table_names"></a> [table\_names](#input\_table\_names) | Name of the DynamoDB tables | `list(string)` | <pre>[<br>  "tweets-raw",<br>  "tweets-processed"<br>]</pre> | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | `"CC-2024Q1-G2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->