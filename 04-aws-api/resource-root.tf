// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration


# Use the api `root_resource_id´ not as the resource for root

resource aws_api_gateway_method root {
  rest_api_id   = aws_api_gateway_rest_api.hello.id
  resource_id   = aws_api_gateway_rest_api.hello.root_resource_id
  http_method   = "ANY"  # << GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY
  authorization = "NONE" # << NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS
}

resource aws_api_gateway_integration root {
  rest_api_id = aws_api_gateway_rest_api.hello.id
  resource_id = aws_api_gateway_method.root.resource_id
  http_method = aws_api_gateway_method.root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_js.invoke_arn
}
