// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration


resource aws_api_gateway_resource catch_all {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   parent_id   = aws_api_gateway_rest_api.hello.root_resource_id
   path_part   = "{any+}" # << "{any+}" matches any path, but not empty!!
}

resource aws_api_gateway_method catch_all {
   rest_api_id   = aws_api_gateway_rest_api.hello.id
   resource_id   = aws_api_gateway_resource.catch_all.id
   http_method   = "ANY"   # << GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY
   authorization = "NONE"  # << NONE, CUSTOM, AWS_IAM, COGNITO_USER_POOLS
}

resource aws_api_gateway_integration catch_all {
   rest_api_id = aws_api_gateway_rest_api.hello.id
   resource_id = aws_api_gateway_method.catch_all.resource_id
   http_method = aws_api_gateway_method.catch_all.http_method

   integration_http_method = "POST" # << only valid value for lambda invocation
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello_js.invoke_arn
}
