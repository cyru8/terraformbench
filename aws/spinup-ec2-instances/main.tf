resource "aws_instance" "techpro-ec2-instances" {
  count = 3
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    "Name" = "techpro-${count.index}"
  }
}