# Configure the AWS Provider
provider "aws" {
  region = local.region
}


resource "aws_iam_role_policy_attachment" "dynamoDb" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.gql_dynamoDb.arn}"
}

resource "aws_iam_role_policy_attachment" "basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = "${aws_iam_role.iam_for_lambda.name}"
}

resource "aws_iam_policy" "gql_dynamoDb" {
  name        = "${local.resource_prefix}-gql-dynamodb"
  description = "Policy for dynamo db access"
  policy      = data.aws_iam_policy_document.gql_dynamoDb.json
}

data "aws_iam_policy_document" "gql_dynamoDb" {
  statement {
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeTable"
    ]
    effect    = "Allow"
    resources = [local.dynamo_arn]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_gql_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
    }
  )

}

resource "aws_lambda_function" "gql_lambda" {
  filename      = "./function/function.zip"
  function_name = "simple_gql_lambda_v"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "graphql.graphqlHandler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("./function/function.zip")

  runtime = "nodejs14.x"

  environment {
    variables = {
      foo    = "bar"
      please = "work"
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gql_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.gql.execution_arn}/*/*"
}
