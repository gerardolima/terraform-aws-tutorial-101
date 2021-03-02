// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function


resource aws_lambda_function hello_js {
  runtime          = "nodejs14.x"
  function_name    = "hello_js"      # name shown on AWS
  handler          = "index.handler" # zip file MUST have a file named `index.js`; this file MUST export a function `handler`
  filename         = "hello_js.zip"  # keep this in synch with `source_code_hash`
  source_code_hash = filebase64sha256("hello_js.zip")

  role = aws_iam_role.hello_runner.arn

  environment {
    variables = {
      MyEnvVar = "Just a simple example of environment variable for the lambda runtime."
    }
  }

  # Use merge() to compose on previous maps
  tags = merge(local.project_tags, {
    Language = "JavaScript" # << overwrite value for Language
    Runtime  = "Node.js"    # << new key-value pair
  })
}
