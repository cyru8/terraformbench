# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# 1. Create vpc
resource "aws_vpc" "vpc001" {
    cidr_block = "10.0.0.0/16"

tags = {
    Name = "prod-vpc"
    }
}

resource "aws_vpc" "vpc002" {
    cidr_block = "10.1.0.0/16"

    tags = {
        Name = "dev-vpc"
    }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gway" {
  vpc_id = aws_vpc.vpc001.id

  tags = {
    Name = "main-internet-gateway"
  }
}
# 3. Create Custom Route Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.vpc001.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.gway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gway.id
  }

  tags = {
    Name = "Prod-Route-Table"
  }
}

# 4a. Create Prod subnet
variable "subnet_prefix-prod" {
    description = "cidr block for production subnet"
    type = string
    #default = "10.0.1.0/24"
}

resource "aws_subnet" "subnet-001vpc" {
  vpc_id     = aws_vpc.vpc001.id
  cidr_block = var.subnet_prefix-prod
  availability_zone = "us-east-2a"

  tags = {
    Name = "prod-lansubnet-001"
  }
}

# 4b. Create Dev subnet
variable "subnet_prefix-dev" {
    description = "cidr block for production subnet"
    type = string
    #default = "10.1.1.0/24"
}

resource "aws_subnet" "subnet-002vpc" {
  vpc_id     = aws_vpc.vpc002.id
  cidr_block = var.subnet_prefix-dev
  availability_zone = "us-east-2a"

  tags = {
    Name = "dev-lansubnet-001"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "prod-route-table-associ" {
  subnet_id      = aws_subnet.subnet-001vpc.id
  route_table_id = aws_route_table.prod-route-table.id
}
# resource "aws_route_table_association" "dev-route-table-associ" {
#   subnet_id      = aws_subnet.subnet-002vpc.id
#   route_table_id = aws_route_table.dev-route-table.id
# }

# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.vpc001.id

#   variable "https_server_port" {
#     description = "Web Server HTTPS Port"
#     type = string
# }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [aws_vpc.main.cidr_block]
  }

# variable "http_server_port" {
#     description = "Web Server HTTP Port"
#     type = string
# }
ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [aws_vpc.main.cidr_block]
  }
# variable "ssh_server_port" {
#     description = "Server SSH Port"
#     type = string
# }
ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = [aws_vpc.main.cidr_block]
  }

egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow_Web"
  }
}

# 7. Create a network interface with an IP in the subnet that was create in step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-001vpc.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

#   attachment {
#     instance     = aws_instance.project-1.id
#     device_index = 1
#   }
}

# 8. Assign an elastic IP to the newtwork interface created in step 7
resource "aws_eip" "eip-one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gway]
}
# 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "project-1" {
  ami          = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "main-key"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
            #!/bin/bash
            sudo apt update -y
            sudo apt install apache2 -y
            sudo systemctl start apache2
            sudo bash -c echo "Your very first Terraform Powered Web Server. - Brewed by Cyru8" > /var/www/html/index.html
            EOF

  tags = {
    Name = "project-1"
  }
}

output "server_public_ip" {
    value = aws_eip.eip-one.public_ip
    description = "The public IP address of the Web Server"  
}

output "server_private_ip" {
    value = aws_instance.project-1.private_ip
    #value = aws_instance.project-1.id
}

output "server_id" {
    value = aws_instance.project-1.id
}