
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

variable "logging_bucket" {
  description = "S3 bucket to send request logs to the VPC flow log bucket to"
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
