# Gateway api
resource "aws_api_gateway_rest_api" "example" {
  name        = "SimpleCallAndResponse"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_account" "example" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement": [
      {
        Sid: "",
        Effect: "Allow",
        Principal: {
          Service: "apigateway.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role       = "${aws_iam_role.cloudwatch.name}"
}

// https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
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
  stage_name  = "whatsmyname"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_rest_api.example.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

data "aws_route53_zone" "arthurneedsadomain" {
  name         = "arthurneedsadomain.com"
}

data "aws_acm_certificate" "amazon_issued" {
  domain      = "api.arthurneedsadomain.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "example" {
  domain_name              = "api.arthurneedsadomain.com"
  regional_certificate_arn = data.aws_acm_certificate.amazon_issued.arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

//data "aws_api_gateway_domain_name" "example" {
//  domain_name = "api.arthurneedsadomain.com"
//}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.arthurneedsadomain.zone_id
  name    = "api.arthurneedsadomain.com"
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
    evaluate_target_health = false
  }
}