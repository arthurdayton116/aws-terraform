//https://kulasangar.medium.com/creating-and-attaching-an-aws-iam-role-with-a-policy-to-an-ec2-instance-using-terraform-scripts-aa85f3e6dfff
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "${local.resource_prefix}-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
  local.base_tags,
  {
    Name = "${local.resource_prefix}-s3-role"
    directory = basename(path.cwd)
  },
  )

}

resource "aws_iam_policy" "s3_policy" {
    name        = "${local.resource_prefix}-s3_access_all_buckets"
    description = "Policy for access to all buckets"
    policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = "s3:*"
        Resource =  "*"
      }]
    })
  }

resource "aws_iam_policy_attachment" "s3_policy_attach" {
  name       = "${local.resource_prefix}-s3-policy-attachment"
  roles      = [aws_iam_role.ec2_s3_access_role.name]
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name  = "${local.resource_prefix}-ec2-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}
