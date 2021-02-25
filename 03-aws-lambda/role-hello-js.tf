// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role


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

resource aws_iam_role "role-hello-js" {
  name               = "role-hello-js"
  path               = "/service-role/"
  tags               = var.project_tags
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

# Alternative way to attach roles, instead of using `managed_policy_arns`
# resource aws_iam_role_policy_attachment basic {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.iam_for_lambda.name
# }
