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
    name        = "${local.resource_prefix}-s3-world-bucket"
    description = "Policy for access to the world bucket"
    policy      = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = "s3:*"
        Resource =  ["${aws_s3_bucket.mc.arn}/*",
          "${aws_s3_bucket.mc.arn}"
          ]
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
