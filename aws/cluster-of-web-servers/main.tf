# ------------------------------------------------------------------------------
# CONFIGURE AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-2"
}

# ---------------------------------------------------------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# Every AWS accout has slightly different availability zones in each region. For example, one account might have
# us-east-1a, us-east-1b, and us-east-1c, while another will have us-east-1a, us-east-1b, and us-east-1d. This resource
# queries AWS to fetch the list for the current account and region.
# ---------------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "all" {}

# ----------------------------------------------------------------------------------
# CREATE THE AUTO SCALING GROUP - ASG
# ----------------------------------------------------------------------------------
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id  
  availability_zones   = data.aws_availability_zones.all.names 
  
  load_balancers    = [aws_elb.example.name]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10  
  
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# ------------------------------------------------------------------------------------
#CREATE THE CLASSIC LOADBALANCER CLB
# ------------------------------------------------------------------------------------
resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  security_groups    = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names  
  
  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}

# ----------------------------------------------------------------------------------
# DECLARE VARIABLE FOR SERVER PORT
# -----------------------------------------------------------------------------------
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "elb_port" {
  description = "The port Elastic Load Balancer will use to serve the site"
  type        = number
  default     = 80
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
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0c55b159cbfafe1f0"
  #ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  #vpc_security_group_ids = [aws_security_group.instance.id]
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Clustered World!!! - Brewed By: Cyru8" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  
  lifecycle {
    create_before_destroy = true
  }
  
}