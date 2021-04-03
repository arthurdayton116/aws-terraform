resource "aws_iam_group" "mc_users" {
  name = "${local.resource_prefix}-minecraft_users"
  path = "/users/"
}

//resource "aws_iam_policy_attachment" "policy_boundary" {
//  name       = "${local.resource_prefix}-mc-policy-boundary"
//  groups     = [aws_iam_group.mc_users.id]
//  policy_arn = aws_iam_policy.minecraft_policy_boundary.arn
//}

resource "aws_iam_policy_attachment" "policy_ec2" {
  name       = "${local.resource_prefix}-mc-policy-ec2"
  groups     = [aws_iam_group.mc_users.id]
  policy_arn = aws_iam_policy.minecraft_ec2.arn
}

//resource "aws_iam_policy_attachment" "policy_ec2_nrb" {
//  name       = "${local.resource_prefix}-mc-policy-ec2_nrb"
//  groups     = [aws_iam_group.mc_users.id]
//  policy_arn = aws_iam_policy.ec2_non_resource_based_policy.arn
//}

resource "aws_iam_group_membership" "mc_users" {
  name = "${local.resource_prefix}-mc_users"

  users = [
    aws_iam_user.mc_one.name,
  ]

  group = aws_iam_group.mc_users.name
}