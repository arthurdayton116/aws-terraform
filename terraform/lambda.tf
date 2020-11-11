resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "../function/function.zip"
  function_name = "simple_go_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("../function/function.zip")

  runtime = "go1.x"

  environment {
    variables = {
      foo = "bar"
      please = "work"
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_rest_api.example.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "test"
}

output "base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}
//
//resource "aws_lambda_permission" "main" {
//  statement_id = "AllowExecutionFromAPIGateway"
//  action = "lambda:InvokeFunction"
//  function_name = aws_lambda_function.test_lambda.function_name
//  principal = "apigateway.amazonaws.com"
//
//  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
//}
//
//resource "aws_api_gateway_rest_api" "main" {
//  name = "${var.resource_prefix}_restapi"
//}
//
//resource "aws_api_gateway_resource" "main" {
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  parent_id = aws_api_gateway_rest_api.main.root_resource_id
//  path_part = "simplego"
//}
//
//resource "aws_api_gateway_integration" "main" {
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  resource_id = aws_api_gateway_resource.main.id
//  http_method = aws_api_gateway_method.main.http_method
//  integration_http_method = aws_api_gateway_method.main.http_method
//  type = "AWS_PROXY"
//  uri = aws_lambda_function.test_lambda.invoke_arn
//}
//
//resource "aws_api_gateway_integration_response" "main" {
//  depends_on = [aws_api_gateway_integration.main]
//
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  resource_id = aws_api_gateway_resource.main.id
//  http_method = aws_api_gateway_method.main.http_method
//  status_code = aws_api_gateway_method_response.main.status_code
//}
//
//resource "aws_api_gateway_method" "main" {
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  resource_id = aws_api_gateway_resource.main.id
//  http_method = "POST"
//  authorization = "NONE"
//}
//
//resource "aws_api_gateway_deployment" "main" {
//  depends_on = [
//    "aws_api_gateway_integration_response.main",
//    "aws_api_gateway_method_response.main",
//  ]
//  rest_api_id = aws_api_gateway_rest_api.main.id
//}
//
//resource "aws_api_gateway_method_settings" "main" {
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  stage_name = aws_api_gateway_stage.main.stage_name
//
//  # settings not working when specifying the single method
//  # refer to: https://github.com/hashicorp/terraform/issues/15119
//  method_path = "*/*"
//
//  settings {
//    throttling_rate_limit = 5
//    throttling_burst_limit = 10
//  }
//}
//
//resource "aws_api_gateway_stage" "main" {
//  stage_name = "sample-stage"
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  deployment_id = aws_api_gateway_deployment.main.id
//}
//
//resource "aws_api_gateway_method_response" "main" {
//  rest_api_id = aws_api_gateway_rest_api.main.id
//  resource_id = aws_api_gateway_resource.main.id
//  http_method = aws_api_gateway_method.main.http_method
//  status_code = "200"
//}
//
//output "endpoint" {
//  value = "${aws_api_gateway_stage.main.invoke_url}${aws_api_gateway_resource.main.path}"
//}