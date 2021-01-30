# ------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}
# ----------------------------------------------------------------------------------
# DECLARE VARIABLE FOR SERVER PORT
# -----------------------------------------------------------------------------------
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

# -------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
# -------------------------------------------------------------------------------------
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"  
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------------------------------------------------------------------
# CREATE A LAUNCH CONFIGURATION THAT DEFINES EACH EC2 INSTANCE IN THE ASG
# ------------------------------------------------------------------------------------
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World - Brewed By: Cyru8" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  
  tags = {
    Name = "terraform-example"
  }
}
# --------------------------------------------------------------------------------------------
# PRINTS THE PUBPLIC IP ADDRESS OF EC2 INSTANCE
# -------------------------------------------------------------------------------------------
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the web server"
}
