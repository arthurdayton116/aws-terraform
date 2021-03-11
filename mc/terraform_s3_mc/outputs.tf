output "s3_bucket_address" {
  value = aws_s3_bucket.mc.bucket_domain_name
}

output "s3_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "s3_bucket_id" {
  value = aws_s3_bucket.mc.id
}
