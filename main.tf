resource "aws_cloudwatch_log_group" "vpcflowlog_cwl_group" {
  name_prefix       = "vpcflowlog-${var.vpc_id}"
  kms_key_id        = aws_kms_key.vpcflowlog_key.arn
  retention_in_days = 30
  tags              = merge(local.common_tags, var.additional_tags)
}

data "aws_iam_policy_document" "vpcflowlog_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
        "logs:CreateLogDelivery",
        "logs:DeleteLogDelivery"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vpcflowlog_policy" {
  name_prefix = "vpcflowlog-"
  policy      = data.aws_iam_policy_document.vpcflowlog_policy_doc.json
}

data "aws_iam_policy_document" "vpcflowlog_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vpcflowlog_role" {
  name_prefix        = "vpcflowlog-role"
  assume_role_policy = data.aws_iam_policy_document.vpcflowlog_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "vpcflowlog-attach-localconfig-policy" {
  role       = aws_iam_role.vpcflowlog_role.name
  policy_arn = aws_iam_policy.vpcflowlog_policy.arn
}

resource "aws_flow_log" "vpcflowlog_cwl" {
  iam_role_arn   = aws_iam_role.vpcflowlog_role.arn
  log_group_name = aws_cloudwatch_log_group.vpcflowlog_cwl_group.name
  traffic_type   = "ALL"
  vpc_id         = var.vpc_id
  
}

resource "aws_flow_log" "vpcflowlog_s3" {
  log_destination       = aws_s3_bucket.vpcflowlog_bucket.arn
  log_destination_type  = "s3"
  traffic_type          = "ALL"
  vpc_id                = var.vpc_id
}
