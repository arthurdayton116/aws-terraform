output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

output "dynamo_db" {
  value = aws_dynamodb_table.i
}

output "ecr" {
  value = aws_ecr_repository.lambda
}