// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource


resource aws_api_gateway_rest_api hello {
  name        = "hello"
  description = "API Gateway declared by Terraform resources"

  endpoint_configuration {
    types = ["REGIONAL"] # << EDGE, REGIONAL, PRIVATE
  }
}

resource aws_api_gateway_resource catch_all {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   parent_id   = aws_api_gateway_rest_api.hello.root_resource_id
   path_part   = "{any+}" # << "{any+}" matches any path, but not empty!!
}

resource aws_api_gateway_method catch_all {
   rest_api_id   = aws_api_gateway_rest_api.hello.id
   resource_id   = aws_api_gateway_resource.catch_all.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource aws_api_gateway_integration catch_all {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   resource_id = aws_api_gateway_method.catch_all.resource_id
   http_method = aws_api_gateway_method.catch_all.http_method

   integration_http_method = "POST" # << only valid value for lambda invocation
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello_js.invoke_arn
}

resource aws_api_gateway_deployment dev {
   depends_on = [
     aws_api_gateway_integration.catch_all,
   ]

   rest_api_id = aws_api_gateway_rest_api.hello.id
   stage_name  = "dev"
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
