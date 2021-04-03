resource "aws_iam_role" "minecraft_role" {
  name = "${local.resource_prefix}-minecraft-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    local.base_tags,
    {
      Name      = "${local.resource_prefix}-minecraft-role"
      directory = basename(path.cwd)
    },
  )

}

//resource "aws_iam_instance_profile" "VPCLockDown" {
//  name = "${local.resource_prefix}-vpc-lockodwn-profile"
//  role = aws_iam_role.vpc_lockdown.name
//}

//resource "aws_iam_role" "vpc_lockdown" {
//  name = "${local.resource_prefix}-vpc-lockdown-role"
//  assume_role_policy = jsonencode({
//    Version = "2012-10-17"
//    Statement = [
//      {
//        Action = "*"
//        Effect = "Allow"
//        Sid    = "vpc-lockdown-role"
//        Principal = {
//          Service = "ec2.amazonaws.com"
//        }
//      },
//    ]
//  })
//
//  tags = merge(
//    local.base_tags,
//    {
//      Name      = "${local.resource_prefix}-vpc-lockdown-role"
//      directory = basename(path.cwd)
//    },
//  )
//
//}



