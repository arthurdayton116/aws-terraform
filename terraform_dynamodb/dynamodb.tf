resource "aws_dynamodb_table" "i" {
  name             = "${local.resource_prefix}-test"
  hash_key         = "TestTableHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "TestTableHashKey"
    type = "S"
  }

  tags = merge(
  local.base_tags,
  {
    Name = "${local.resource_prefix}-test"
  },
  )
}

variable "number_of_records" {
  default = 5
}

resource "random_string" "one" {
  count = var.number_of_records
  length           = 8
}

resource "random_string" "two" {
  count = var.number_of_records
  length           = 8
}

resource "aws_dynamodb_table_item" "i" {
  count = var.number_of_records
  table_name = aws_dynamodb_table.i.name
  hash_key   = aws_dynamodb_table.i.hash_key

  item = <<ITEM
{
  "TestTableHashKey": {"S": "${uuid()}"},
  "one": {"S": "${random_string.one[count.index].result}"},
  "two": {"S": "${random_string.two[count.index].result}"}
}
ITEM
}