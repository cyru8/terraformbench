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
  region  = var.region
}

resource "aws_instance" "test-instance01" {
  ami = var.ami
  instance_type = "t2.micro"

  tags = {
    Name = var.instanceName
  }

}

resource "aws_eip" "eip01-ip" {
  vpc      = true
  instance = aws_instance.test-instance01.id
}

output "ip" {
    value = aws_eip.eip01-ip.public_ip
}