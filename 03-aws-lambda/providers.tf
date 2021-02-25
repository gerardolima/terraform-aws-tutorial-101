# declare all providers used

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # short form of "registry.terraform.io/hashicorp/aws"
      version = "~> 3.27"
    }
  }
}
