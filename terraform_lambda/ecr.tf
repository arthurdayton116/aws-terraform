resource "aws_ecr_repository" "lambda" {
  name                 = "${local.resource_prefix}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    local.base_tags,
    {
      Name = "${local.resource_prefix}-ecr"
    },
  )
}