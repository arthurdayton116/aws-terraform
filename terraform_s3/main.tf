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

//aws s3 cp mc_16_4_server.jar  s3://sample-company-bucket/mcBackup/mc_16_4_server.jar
//aws s3 cp s3://sample-company-bucket/mcBackup/mc_16_4_server.jar mc_16_4_server.jar
//https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonS3.html

//aws s3 sync . s3://sample-company-bucket/mcBackup/

//https://tecadmin.net/install-s3cmd-manage-amazon-s3-buckets/#
