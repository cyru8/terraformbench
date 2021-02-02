terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "test-instance01" {
  ami           = "ami-0f052119b3c7e61d1"
  instance_type = "t2.micro"

  tags = {
    Name = "test-instance01"
  }

}

