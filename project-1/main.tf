# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Create a resource
resource "aws_instance" "project-1" {
  ami          = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "project-1"
  }
}

output "public_ip" {
    value = aws_instance.project-1.public_ip
    description = "The publicIP address of the Web Server"  
}