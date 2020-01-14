# terraform-aws-vpcflowlogs


[![](https://github.com/rhythmictech/terraform-aws-vpcflowlogs/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-vpcflowlogs/actions)

Enable VPC Flowlogs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| logging\_bucket | S3 bucket to send request logs to the VPC flow log bucket to | string | n/a | yes |
| region | Region VPC flow logs will be sent to | string | n/a | yes |
| tags | Tags to include on resources that support it | map(string) | `{}` | no |
| vpc\_ids | List of VPCs to enable flow logging for | list(string) | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
