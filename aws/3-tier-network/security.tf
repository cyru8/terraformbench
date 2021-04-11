# Security Groups

resource "aws_security_group" "out_ssh_bastion_sg" {
  name = "allow_outbound_ssh"
  description = "Allows outbound SSH traffic"
  vpc_id = "aws_vpc.main.id"

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "SSH OUT from Bastion "
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # prefix_list_ids = [ "value" ]
    # security_groups = [ "value" ]
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "inbound ssh to bastion from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # security_groups = [ "value" ]
    # prefix_list_ids = [ "value" ]
  }

  tags = {
    Project = "out_ssh_bastion_sg"
  }
}

resource "aws_security_group" "out_http_app_sg" {
  name = "allows_http"
  description = "allows inbound and outbound http traffic for app"
  vpc_id = "aws_vpc.main.id"

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allows TCP internet traffic egress from app layer"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    # security_groups = [ "value" ] 
    # prefix_list_ids = [ "value" ]
  }
  
  tags = {
    Project = "out_http_app_sg"
  }
}