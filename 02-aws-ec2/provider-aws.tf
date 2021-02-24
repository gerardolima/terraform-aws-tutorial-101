variable "aws_profile" {
  description = "A previously configured profile on AWS cli tool"
  type = string
}

provider "aws" {
  profile = var.aws_profile # << TF_VAR_aws_profile
  region  = "eu-west-1"
}
