
data "aws_caller_identity" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id

  common_tags = {
    namespace = var.namespace
    env       = var.env
    owner     = var.owner
  }
}


variable "additional_tags" {
  default = {}
  type    = map(string)
}

variable "namespace" {
  type = string
}

variable "env" {
  type = string
}

variable "owner" {
  type = string
}

variable "region" {
  type = string
}

variable "logging_bucket" {
  type = string
}

variable "vpc_id" {
  type = string
}

