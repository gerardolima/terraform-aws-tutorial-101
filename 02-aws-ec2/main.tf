terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # short form of "registry.terraform.io/hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}
