// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function


resource aws_lambda_function "lambda-hello-js" {
  runtime          = "nodejs14.x"
  function_name    = "lambda-hello-js"     # name shown on AWS
  handler          = "index.handler"       # zip file MUST have a file named `index.js`; this file MUST export a function `handler`
  filename         = "lambda-hello-js.zip" # keep this in synch with `source_code_hash`
  source_code_hash = filebase64sha256("lambda-hello-js.zip")

  role = aws_iam_role.role-hello-js.arn

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
