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
  tags               = var.project_tags
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

# Alternative way to attach roles:
# resource aws_iam_role_policy_attachment basic {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.iam_for_lambda.name
# }

resource aws_lambda_function "hello-lambda-js" {
  runtime          = "nodejs14.x"
  function_name    = "hello-lambda-js"     # name shown on AWS
  handler          = "index.handler"       # zip file MUST have a file named `index.js`; this file MUST export a function `handler`
  filename         = "hello-lambda-js.zip" # keep this in synch with `source_code_hash`
  source_code_hash = filebase64sha256("hello-lambda-js.zip")

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