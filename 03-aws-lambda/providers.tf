/**
  resources:
  - https://registry.terraform.io/providers/hashicorp/aws/latest
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # short form of "registry.terraform.io/hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider aws {
  profile = var.aws_profile
  region  = var.aws_region
}
