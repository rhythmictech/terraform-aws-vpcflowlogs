locals {
  bucket     = var.create_bucket ? aws_s3_bucket.this[0].arn : var.vpcflowlog_bucket
  kms_key_id = var.create_kms_key ? aws_kms_key.this[0].arn : var.vpcflowlog_kms_key
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.log_to_cloudwatch ? 1 : 0
  name_prefix       = "vpcflowlog"
  kms_key_id        = local.kms_key_id
  retention_in_days = 30
  tags              = var.tags
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix        = "vpcflowlog-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogDelivery",
      "logs:DeleteLogDelivery"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "this" {
  name_prefix = "vpcflowlog-"
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "vpcflowlog-attach-localconfig-policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_flow_log" "cloudwatch" {
  count           = var.log_to_cloudwatch ? length(var.vpc_ids) : 0
  iam_role_arn    = aws_iam_role.this.arn
  log_destination = aws_cloudwatch_log_group.this[count.index].arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_ids[count.index]
}

resource "aws_flow_log" "s3" {
  count                = var.log_to_s3 ? length(var.vpc_ids) : 0
  log_destination      = "arn:aws:s3:::${local.bucket}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_ids[count.index]
}
