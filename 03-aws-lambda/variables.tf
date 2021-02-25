/**
  resources
  - https://www.terraform.io/docs/cli/config/environment-variables.html#tf_var_name
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging
*/

variable aws_profile { # << $TF_VAR_aws_profile
  description = "A previously configured profile on AWS cli tool"
  type        = string
}

variable project_tags {
  description = "Tags to be applied to all resources on this project"
  type        = map(string)
  default = {
    Terraform = true
    Project   = "03-aws-lambda"
    Foo       = "bar"
  }
}
