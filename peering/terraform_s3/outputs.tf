output "dynamic_ec2_s3_instance_profile_name" {
  value = aws_iam_instance_profile.dynamic_ec2_profile.name
}

output "dynamic_ec2_s3_bucket_id" {
  value = aws_s3_bucket.dynamic_ec2.id
}
