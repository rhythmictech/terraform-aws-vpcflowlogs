# terraform-aws-vpcflowlogs

[![](https://github.com/rhythmictech/terraform-aws-vpcflowlogs/workflows/check/badge.svg)](https://github.com/rhythmictech/terraform-aws-vpcflowlogs/actions)

Configure VPC flow logs for one or more VPCs. Supports creating a KMS key and S3 bucket or using an existing bucket. Useful when shipping flow logs to a separate account. Note that the KMS key and S3 bucket will need to have the appropriate policies in place to accept logs from another account. See [terraform-aws-vpcflowlog-bucket](https://github.com/rhythmictech/terraform-aws-vpc-flowlog-bucket) for a suitable example.

Example:

```
module "vpcflowlogs" {
  #source         = "git::https://github.com/rhythmictech/terraform-aws-vpcflowlogs.git"
  logging_bucket     = "example-s3-access-logs-bucket"
  region             = "us-east-1"
  tags               = local.tags
  vpc_ids            = ["vpc-1234567890"]
}
```

Using an external key/bucket:

```
module "vpcflowlogs" {
  #source         = "git::https://github.com/rhythmictech/terraform-aws-vpcflowlogs.git"
  create_bucket      = false
  create_kms_key     = false
  region             = "us-east-1"
  tags               = local.tags
  vpc_ids            = ["vpc-1234567890"]
  vpcflowlog_bucket  = "example-s3-vpcflowlogs-bucket"
  vpcflowlog_kms_key = "arn:aws:kms:us-east-1:123456789012:key/..."
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_flow_log.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.vpcflowlog-attach-localconfig-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.vpcflowlog_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Create S3 bucket to receive VPC flow logs? `vpcflowlog_bucket` must be specified if this is false. | `bool` | `true` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create KMS key to encrypt flow logs? `vpcflowlog_kms_key` must be specified if this is false. | `bool` | `true` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | KMS Key Alias for VPC flow log KMS key | `string` | `"vpcflowlog_key"` | no |
| <a name="input_log_to_cloudwatch"></a> [log\_to\_cloudwatch](#input\_log\_to\_cloudwatch) | Should VPC flow logs be written to CloudWatch Logs | `bool` | `true` | no |
| <a name="input_log_to_s3"></a> [log\_to\_s3](#input\_log\_to\_s3) | Should VPC flow logs be written to S3 | `bool` | `true` | no |
| <a name="input_logging_bucket"></a> [logging\_bucket](#input\_logging\_bucket) | S3 bucket to send request logs to the VPC flow log bucket to (required if `create_bucket` is true) | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region VPC flow logs will be sent to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to include on resources that support it | `map(string)` | `{}` | no |
| <a name="input_vpc_ids"></a> [vpc\_ids](#input\_vpc\_ids) | List of VPCs to enable flow logging for | `list(string)` | n/a | yes |
| <a name="input_vpcflowlog_bucket"></a> [vpcflowlog\_bucket](#input\_vpcflowlog\_bucket) | S3 bucket to receive VPC flow logs (required it `create_bucket` is false) | `string` | `""` | no |
| <a name="input_vpcflowlog_kms_key"></a> [vpcflowlog\_kms\_key](#input\_vpcflowlog\_kms\_key) | KMS key to use for VPC flow log encryption (required it `create_kms_key` is false) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS key |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The name of the bucket flow logs are routing to |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Related Projects
* [VPC Flow Log Bucket](https://github.com/rhythmictech/terraform-aws-vpc-flowlog-bucket)
