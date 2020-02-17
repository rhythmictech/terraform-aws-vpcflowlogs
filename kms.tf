data "aws_iam_policy_document" "key" {

  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "this" {
  count                   = var.create_kms_key ? 1 : 0
  deletion_window_in_days = 7
  description             = "VPC Flow Log Encryption Key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key.json
  tags = merge(
    {
      "Name" = "vpcflowlog-key"
    },
    var.tags
  )
}

resource "aws_kms_alias" "this" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.this[0].id
}
