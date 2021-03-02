resource "aws_s3_bucket" "mc" {
  bucket = "${local.resource_prefix}-bucket"
  acl    = "private"
  force_destroy = false
  tags = merge(
  local.base_tags,
  {
    Name = "${local.resource_prefix}-mc-s3"
    directory = basename(path.cwd)
  },
  )
}
