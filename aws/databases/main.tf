#-----
#Deploy Mysql on RDS
#-----

#-----
#Requires a specific Teraform version or higher
#-----
terraform {
  required_version = ">= 0.12.26"
}

#-----
#Configure our AWS Connection
#------
provider "aws" {
    region = "us-east-2"
}

#---- 
#Deploy Mysql on RDS
#----
resource "aws_db_instance" "dev" {
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "my_db_01"
  username = "admin"
  password = var.db_password

  #---
  #Dont copy below stanza to production. It's solely to make it quicker to delete this DB
  #----
  skip_final_snapshot = true
}