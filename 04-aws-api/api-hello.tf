// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource


resource aws_api_gateway_rest_api "api-hello-resource" {
  name        = "api-hello-resource"
  description = "API Gateway declared by Terraform resources"

  endpoint_configuration {
    types = ["REGIONAL"] # << EDGE, REGIONAL, PRIVATE
  }
}

resource aws_api_gateway_resource "resource-hello-resource" {
   rest_api_id = aws_api_gateway_rest_api.api-hello-resource.id
   parent_id   = aws_api_gateway_rest_api.api-hello-resource.root_resource_id
   path_part   = "{any+}" # << "{any+}" matches any path
}

resource aws_api_gateway_method "method-hello-resource" {
   rest_api_id   = aws_api_gateway_rest_api.api-hello-resource.id
   resource_id   = aws_api_gateway_resource.resource-hello-resource.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource aws_api_gateway_integration "integration-hello-resource" {
   rest_api_id = aws_api_gateway_rest_api.api-hello-resource.id
   resource_id = aws_api_gateway_method.method-hello-resource.resource_id
   http_method = aws_api_gateway_method.method-hello-resource.http_method

   integration_http_method = "POST" # << only valid value for lambda invocation
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.lambda-hello-js.invoke_arn
}

resource aws_api_gateway_deployment "deployment-hello-resource" {
   depends_on = [
     aws_api_gateway_integration.integration-hello-resource,
   ]

   rest_api_id = aws_api_gateway_rest_api.api-hello-resource.id
   stage_name  = "dev"
}

resource aws_lambda_permission "permission-hello-resource" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda-hello-js.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.api-hello-resource.execution_arn}/*/*"
}

output base_url {
  value = aws_api_gateway_deployment.deployment-hello-resource.invoke_url
}
