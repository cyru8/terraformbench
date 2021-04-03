# ----------------------------------------------------------------------------------------------
# PRINTS THE NAME OF THE SITE WHICH IS THE ELB NAME
# -------------------------------------------------------------------------------------------
output "clb_dns_name" {
  value       = aws_elb.web-server-cluster.dns_name
  description = "The domain name of the load balancer"
}