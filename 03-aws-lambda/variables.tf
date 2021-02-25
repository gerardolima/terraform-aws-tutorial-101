/**
  resources
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/resource-tagging
*/

variable "project_tags" {
  description = "Tags to be applied to all resources on this project"
  type        = map(string)
  default =   {
    Terraform = true
    Project   = "03-aws-lambda"
    Foo       = "bar"
  }
}
