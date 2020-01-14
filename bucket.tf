

resource "aws_s3_bucket" "vpcflowlog_bucket" {
  bucket = "${local.account_id}-${var.region}-vpcflowlog"
  acl    = "private"
  tags   = var.tags

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 365
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.vpcflowlog_key.arn
      }
    }
  }

  logging {
    target_bucket = var.logging_bucket
    target_prefix = "${local.account_id}-${var.region}-vpcflowlog/"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.vpcflowlog_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "vpcflowlog_bucket_policy" {
  bucket = aws_s3_bucket.vpcflowlog_bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "delivery.logs.amazonaws.com" },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.vpcflowlog_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "delivery.logs.amazonaws.com" },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.vpcflowlog_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": { "StringEquals": { "s3:x-amz-acl": "bucket-owner-full-control" } }
    }
  ]
}
EOF

}
