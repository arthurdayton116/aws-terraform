resource "aws_iam_user" "mc_one" {
  name = "minecraft_server_admin"

  permissions_boundary = aws_iam_policy.minecraft_policy_boundary.id
  tags = {
    tag-key = "tag-value"
  }
}