variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_vpc_cidr" {
  description = "CIDR block for AWS VPC"
  default     = "10.0.0.0/16"
}

variable "onprem_vpc_cidr" {
  description = "CIDR block for simulated on-prem VPC"
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}
variable "my_ip" {
  description = "Your public IP for SSH access (use https://ifconfig.me)"
  default     = "2.42.134.40" # Override this in terraform.tfvars
}

variable "ssh_key_name" {
  description = "Name of an existing AWS key pair"
  type        = string
  default     = "key-pair-1"
}