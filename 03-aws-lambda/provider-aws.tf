/**
  resources:
  - https://registry.terraform.io/providers/hashicorp/aws/latest
*/

provider aws {
  profile = var.aws_profile
  region  = "eu-west-1"
}
