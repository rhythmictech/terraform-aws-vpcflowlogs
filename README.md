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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_bucket | Create S3 bucket to receive VPC flow logs? `vpcflowlog\_bucket` must be specified if this is false. | bool | `"true"` | no |
| create\_kms\_key | Create KMS key to encrypt flow logs? `vpcflowlog\_kms\_key` must be specified if this is false. | bool | `"true"` | no |
| kms\_alias | KMS Key Alias for VPC flow log KMS key | string | `"vpcflowlog_key"` | no |
| log\_to\_cloudwatch | Should VPC flow logs be written to CloudWatch Logs | bool | `"true"` | no |
| log\_to\_s3 | Should VPC flow logs be written to S3 | bool | `"true"` | no |
| logging\_bucket | S3 bucket to send request logs to the VPC flow log bucket to \(required if `create\_bucket` is true\) | string | `""` | no |
| region | Region VPC flow logs will be sent to | string | n/a | yes |
| tags | Tags to include on resources that support it | map(string) | `{}` | no |
| vpc\_ids | List of VPCs to enable flow logging for | list(string) | n/a | yes |
| vpcflowlog\_bucket | S3 bucket to receive VPC flow logs \(required it `create\_bucket` is false\) | string | `""` | no |
| vpcflowlog\_kms\_key | KMS key to use for VPC flow log encryption \(required it `create\_kms\_key` is false\) | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_key\_id | KMS key |
| s3\_bucket\_name | The name of the bucket flow logs are routing to |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Related Projects
* [VPC Flow Log Bucket](https://github.com/rhythmictech/terraform-aws-vpc-flowlog-bucket)
