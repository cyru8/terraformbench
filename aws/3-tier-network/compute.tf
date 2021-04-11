# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter
# https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/

data "aws_ssm_parameter" "linux_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "jump_box" {
  ami           = data.aws_ssm_parameter.linux_latest_ami.value
  instance_type = "t2.micro"
  key_name      = "sdn_dev_key"

  subnet_id              = aws_subnet.public_subnet.id
  # vpc_security_group_ids = [aws_security_group.general_sec_grp.id, aws_security_group.bastion_sg.id]
  vpc_security_group_ids = [aws_security_group.out_ssh_bastion_sg.id, aws_security_group.out_http_app_sg.id]

  tags = {
    Project = "sdn-dev"
  }
}

resource "aws_instance" "app_instance" {
  ami           = data.aws_ssm_parameter.linux_latest_ami.value
  instance_type = "t2.micro"
  key_name      = "sdn_dev_key"

  subnet_id              = aws_subnet.private_subnet.id
  # vpc_security_group_ids = [aws_security_group.general_sec_grp.id, aws_security_group.app_sg.id]  
  vpc_security_group_ids = [aws_security_group.out_ssh_bastion_sg.id, aws_security_group.out_http_app_sg.id]
  tags = {
    Project = "sdn-dev"
  }
}