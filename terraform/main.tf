
# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# Generate a random S3 bucket name for flow logs
resource "random_pet" "bucket_name" {
  length    = 2
  prefix    = "flow-logs-"
}

# S3 Bucket for VPC Flow Logs
resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket        = random_pet.bucket_name.id
  force_destroy = true # For demo purposes only
}

# Security Group: Allow SSH (for testing firewall rules) and ICMP (for traceroute)
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow SSH and ICMP traffic"
  vpc_id      = aws_vpc.aws_vpc.id

  # SSH access restricted to your IP (override in variables.tf)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Allow ICMP (traceroute)
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in AWS VPC (to test connectivity)
resource "aws_instance" "aws_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.aws_public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = var.ssh_key_name

  tags = {
    Name = "aws-instance"
  }
}

# EC2 Instance in On-Prem VPC (simulated on-premises)
resource "aws_instance" "onprem_vpn_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.onprem_public_subnet.id
  vpc_security_group_ids = [aws_security_group.vpn_sg.id] # Allow IPSec traffic
  key_name               = var.ssh_key_name

  tags = {
    Name = "onprem-vpn-server"
  }
}

# Data source for latest Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group for VPN Server (allow IPSec)
resource "aws_security_group" "vpn_sg" {
  name        = "vpn-sg"
  vpc_id      = aws_vpc.onprem_vpc.id
  description = "Allow IPSec traffic"

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}