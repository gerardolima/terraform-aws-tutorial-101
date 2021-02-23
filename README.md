# Get Started - AWS

Build, change, and destroy AWS infrastructure using Terraform. Step-by-step, command-line tutorials will walk you through the Terraform basics for the first time. https://learn.hashicorp.com/collections/terraform/aws-get-started

## Install Terraform

Install using homebrew
```shell
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
$ brew upgrade hashicorp/tap/terraform
$ terraform -install-autocomplete
$ terraform -version
```

Local test
```shell
$ cd 01-terraform-docker-demo
# see main.tf

# create resources
$ terraform init
$ terraform apply

# see results
$ curl localhost:8000
$ docker ps

# release resources
$ terraform destroy
$ cd ..
```

## Build Infrastructure

Configure AWS cli
```shell
$ aws configure
```

Test on AWS
```shell
$ cd 02-learn-terraform-aws-instance
$ terraform init
$ terraform apply

$ aws ec2 describe-instances --region us-west-2 | jq -c '.Reservations[].Instances[] | (.InstanceId, .State.Name)'

$ terraform destroy
```
