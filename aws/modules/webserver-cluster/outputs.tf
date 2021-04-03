output "clb_dns_name" {
  value       = aws_elb.websrvcluster.dns_name
  description = "The domain name of the load balancer"
}