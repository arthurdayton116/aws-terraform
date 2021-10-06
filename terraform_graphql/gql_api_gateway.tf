# Gateway api
resource "aws_api_gateway_rest_api" "gql" {
  name        = "SimpleGraphQL"
  description = "Terraform Serverless GraphQL Example"
}

resource "aws_api_gateway_account" "example" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global_gql"

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

resource "aws_iam_role_policy_attachment" "cloudwatch_gql" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role       = "${aws_iam_role.cloudwatch.name}"
}

// https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
resource "aws_api_gateway_resource" "gql_method" {
  rest_api_id = aws_api_gateway_rest_api.gql.id
  parent_id   = aws_api_gateway_rest_api.gql.root_resource_id
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.gql.id
  resource_id   = aws_api_gateway_resource.gql_method.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.gql.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.gql_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.gql.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.gql_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "gql" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.gql.id
  stage_name  = "dev_gql"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.gql.id
  resource_id   = aws_api_gateway_rest_api.gql.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

//data "aws_route53_zone" "arthurneedsadomain" {
//  name         = "arthurneedsadomain.com"
//}
//
//data "aws_acm_certificate" "amazon_issued" {
//  domain      = "api.arthurneedsadomain.com"
//  types       = ["AMAZON_ISSUED"]
//  most_recent = true
//}

//resource "aws_api_gateway_domain_name" "example" {
//  domain_name              = "api.arthurneedsadomain.com"
//  regional_certificate_arn = data.aws_acm_certificate.amazon_issued.arn
//
//  endpoint_configuration {
//    types = ["REGIONAL"]
//  }
//}

//data "aws_api_gateway_domain_name" "example" {
//  domain_name = "api.arthurneedsadomain.com"
//}

//resource "aws_route53_record" "api" {
//  zone_id = data.aws_route53_zone.arthurneedsadomain.zone_id
//  name    = "api.arthurneedsadomain.com"
//  type    = "A"
//
//  alias {
//    name                   = aws_api_gateway_domain_name.example.regional_domain_name
//    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
//    evaluate_target_health = false
//  }
//}