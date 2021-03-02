// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission


resource aws_api_gateway_rest_api hello {
  name        = "hello"
  description = "API Gateway declared by Terraform resources"
  endpoint_configuration {
    types = ["REGIONAL"] # << EDGE, REGIONAL, PRIVATE
  }

  tags = local.project_tags
}

resource aws_api_gateway_deployment dev {
  stage_name  = "dev"
  rest_api_id = aws_api_gateway_rest_api.hello.id

  depends_on = [
    aws_api_gateway_integration.catch_all,
  ]
}

resource aws_lambda_permission hello_invoker {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_js.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.hello.execution_arn}/*/*"
}

output base_url {
  value = aws_api_gateway_deployment.dev.invoke_url
}
