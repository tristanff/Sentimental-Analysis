<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.compute_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_task_definition.process_raw_tweets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway_url"></a> [api\_gateway\_url](#input\_api\_gateway\_url) | URL to invoke the API pointing to the stage | `string` | `""` | no |
| <a name="input_container_image_url"></a> [container\_image\_url](#input\_container\_image\_url) | The url of the compute containter image | `string` | `""` | no |
| <a name="input_lab_role_arn"></a> [lab\_role\_arn](#input\_lab\_role\_arn) | ARN of your lab role | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->