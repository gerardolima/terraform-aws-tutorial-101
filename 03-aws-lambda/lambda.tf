/**
  resources
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
*/


data aws_iam_policy_document "AWSLambdaTrustPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource aws_iam_role "iam_for_lambda" {
  name               = "iam_for_lambda"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  tags               = var.project_tags
}

resource aws_lambda_function "test_lambda" {
  runtime          = "nodejs14.x"
  function_name    = "lambda_function_name"
  handler          = "index.handler"
  filename         = "lambda_function_payload.zip"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  role = aws_iam_role.iam_for_lambda.arn

  environment {
    variables = {
      foo = "bar"
    }
  }

  # Use merge() to compose on previous maps
  tags = merge(var.project_tags, {
    Foo   = "potato" # << overwrite the previously defined value for the key
    MyFoo = "MyBar"  # << new key-value pair
  })
}