// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document


data aws_iam_policy_document trust_aws {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource aws_iam_role hello_runner {
  name               = "hello_runner"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.trust_aws.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = local.project_tags
}

# Alternative way to attach roles, instead of using `managed_policy_arns`
# resource aws_iam_role_policy_attachment basic {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.iam_for_lambda.name
# }
