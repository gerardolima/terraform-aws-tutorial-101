# Get Started - AWS

Build, change, and destroy AWS infrastructure using Terraform. Step-by-step, command-line tutorials will walk you through the Terraform basics for the first time. https://learn.hashicorp.com/collections/terraform/aws-get-started

## Install Terraform

Using homwbrew
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
cd ..
```


