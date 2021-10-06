
output "dynamo_db" {
  value = aws_dynamodb_table.i
}

output "dynamo_db_arn" {
  value = aws_dynamodb_table.i.arn
}