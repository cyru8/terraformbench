variable "region" {
    description = "The region where to delpoy this code (e.g. us-east-2)"
    default = "us-east-2"
}

variable "ami" {
    description = "Amazon Image ID to use"
    default = "ami-0f052119b3c7e61d1"
}

variable "instanceName" {
    description = "EC2 Instance name"
    default = "test-instance01"
}