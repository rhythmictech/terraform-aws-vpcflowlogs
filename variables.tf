
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

variable "tags" {
  default = {}
  type    = map(string)
}

variable "region" {
  type = string
}

variable "logging_bucket" {
  type = string
}

variable "vpc_ids" {
  type = list(string)
}

