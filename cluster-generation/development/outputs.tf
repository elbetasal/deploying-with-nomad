output "server_lb_ip" {
  value = aws_elb.server_lb.dns_name
}
