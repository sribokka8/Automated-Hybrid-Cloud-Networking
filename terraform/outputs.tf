output "aws_instance_ip" {
  description = "Public IP of the AWS instance"
  value       = aws_instance.aws_instance.public_ip
}

output "onprem_instance_ip" {
  description = "Public IP of the on-prem instance"
  value       = aws_instance.onprem_vpn_server.public_ip
}