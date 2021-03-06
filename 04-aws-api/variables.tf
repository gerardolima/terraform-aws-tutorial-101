// https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name
// https://www.terraform.io/docs/language/values/locals.html
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging


variable aws_profile { # << $TF_VAR_aws_profile
  description = "A previously configured profile on AWS cli tool."
  type        = string
}

variable aws_region { # << $TF_VAR_aws_region
  description = "The region where AWS operations will take place (eu-west-1, us-east-2, ...)."
  type        = string
}


locals {
  # default project tags
  project_tags = {
    Terraform = true
    Project   = "Terraform-Tutorial-101"
    Language  = "Terraform"
  }
}
