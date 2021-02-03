
provider "aws" {
  region = "us-east-2"
}

provider "random" {}

resource "random_pet" "name" {}

resource "aws_instance" "web" {
  ami           = "ami-03d64741867e7bb94"
  instance_type = "t2.micro"
  user_data     = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = random_pet.name.id
  }
}

output "domain-name" {
  value = aws_instance.web.public_dns
}

output "application-url" {
  value = "${aws_instance.web.public_dns}/index.php"
}


resource "aws_security_group" "web_sg" {
  name        = "${random_pet.name.id}-sg"
  description = "Allow Non-TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "Non-TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # tags = {
  #   Name = "allow_tls"
  # }
}