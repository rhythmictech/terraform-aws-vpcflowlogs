
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

variable "create_bucket" {
  default     = true
  description = "Create S3 bucket to receive VPC flow logs? `vpcflowlog_bucket` must be specified if this is false."
  type        = bool
}

variable "create_kms_key" {
  default     = true
  description = "Create KMS key to encrypt flow logs? `vpcflowlog_kms_key` must be specified if this is false."
  type        = bool
}

variable "kms_alias" {
  default     = "vpcflowlog_key"
  description = "KMS Key Alias for VPC flow log KMS key"
  type        = string
}

variable "log_to_cloudwatch" {
  default     = true
  description = "Should VPC flow logs be written to CloudWatch Logs"
  type        = bool
}

variable "log_to_s3" {
  default     = true
  description = "Should VPC flow logs be written to S3"
  type        = bool
}

variable "logging_bucket" {
  default     = ""
  description = "S3 bucket to send request logs to the VPC flow log bucket to (required if `create_bucket` is true)"
  type        = string
}

variable "region" {
  description = "Region VPC flow logs will be sent to"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to include on resources that support it"
  type        = map(string)
}

variable "vpc_ids" {
  description = "List of VPCs to enable flow logging for"
  type        = list(string)
}

variable "vpcflowlog_bucket" {
  default     = ""
  description = "S3 bucket to receive VPC flow logs (required it `create_bucket` is false)"
}

variable "vpcflowlog_kms_key" {
  default     = ""
  description = "KMS key to use for VPC flow log encryption (required it `create_kms_key` is false)"
}
