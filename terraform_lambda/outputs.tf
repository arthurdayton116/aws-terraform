output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

output "ecr" {
  value = aws_ecr_repository.lambda
}