#VPC
resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  #instance_tenancy = "default"

  tags = {
    Name = "sdn-dev"
  }
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true #This ensures that EC2 in this subnet ia NATted at launch

  tags = {
    Name = "sdn-dev"
  }
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "sdn-dev"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sdn-dev"
  }
}

#Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  #   route {
  #     ipv6_cidr_block        = "::/0"
  #     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  #   }

  tags = {
    Name = "sdn-dev"
  }
}

#Route Table Association
resource "aws_route_table_association" "route_table_associa" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

#NAT Gateway and Elastic IP (Outbound Internet Access)
resource "aws_eip" "nat_elastic_ip" {
  vpc = true

  tags = {
    Project = "sdn-dev"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Project = "sdn-dev"
  }
}

#Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Project = "sdn-dev"
  }
}

resource "aws_route_table_association" "priv_route_table_associa" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
