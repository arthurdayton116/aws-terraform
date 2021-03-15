resource "aws_s3_bucket" "dynamic_ec2" {
  bucket = "${local.resource_prefix}-dynamic-ec2-bucket"
  acl    = "private"
  force_destroy = false
  tags = merge(
  local.base_tags,
  {
    Name = "${local.resource_prefix}-dynamic-ec2-s3"
    directory = basename(path.cwd)
  },
  )
}
