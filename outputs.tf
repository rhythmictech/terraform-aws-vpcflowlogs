output "kms_key_id" {
  description = "KMS key"
  value       = local.kms_key_id
}

output "s3_bucket_name" {
  description = "The name of the bucket flow logs are routing to"
  value       = local.bucket
}
