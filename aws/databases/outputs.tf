output "address" {
  value = aws_db_instance.webdb01.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value = aws_db_instance.webdb01.port
  description = "The port the database is listening on"
}