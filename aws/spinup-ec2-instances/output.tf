output "ec2_machines" {
  value = aws_instance.techpro-ec2-instances.*.arn  # This indicates that there are more than one arn (amazon resource name) based on the count declaration.
}