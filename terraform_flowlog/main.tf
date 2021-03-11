provider "aws" {
  region = local.region
}

resource "aws_flow_log" "i" {
  iam_role_arn    = aws_iam_role.i.arn
  log_destination = aws_cloudwatch_log_group.i.arn
  traffic_type    = "ALL"
  vpc_id          = local.vpc_id

  tags = merge(
  local.base_tags,
  {
    Name = "${local.resource_prefix}-vpc-flowlog"
  },
  )
}

resource "aws_cloudwatch_log_group" "i" {
  name = "${local.resource_prefix}-vpc-flowlog-group"
  tags = merge(
  local.base_tags,
  {
    Name = "${local.resource_prefix}-vpc-flowlog-group"
  },
  )
}
