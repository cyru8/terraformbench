terraform {
  required_version = ">=0.12.26"
}

provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../modules/webserver_cluster"

  cluster_name = "webservers-stage"
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}