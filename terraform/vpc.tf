# AWS VPC
resource "aws_vpc" "aws_vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# On-Prem VPC (simulated)
resource "aws_vpc" "onprem_vpc" {
  cidr_block           = var.onprem_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}



# --------------------------------------------------
# AWS VPC Networking
# --------------------------------------------------
resource "aws_subnet" "aws_public_subnet" {
  vpc_id                  = aws_vpc.aws_vpc.id
  cidr_block              = cidrsubnet(var.aws_vpc_cidr, 8, 1) # 10.0.1.0/24
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "aws_private_subnet" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = cidrsubnet(var.aws_vpc_cidr, 8, 2) # 10.0.2.0/24
  availability_zone = "${var.aws_region}a"
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.aws_vpc.id
}

# --------------------------------------------------
# On-Prem VPC Networking (Simulated)
# --------------------------------------------------
resource "aws_subnet" "onprem_public_subnet" {
  vpc_id                  = aws_vpc.onprem_vpc.id
  cidr_block              = cidrsubnet(var.onprem_vpc_cidr, 8, 1) # 192.168.1.0/24
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "onprem_private_subnet" {
  vpc_id            = aws_vpc.onprem_vpc.id
  cidr_block        = cidrsubnet(var.onprem_vpc_cidr, 8, 2) # 192.168.2.0/24
  availability_zone = "${var.aws_region}b"
}

resource "aws_internet_gateway" "onprem_igw" {
  vpc_id = aws_vpc.onprem_vpc.id
}

# --------------------------------------------------
# Route Tables (Required for Transit Gateway)
# --------------------------------------------------
resource "aws_route_table" "aws_public_rt" {
  vpc_id = aws_vpc.aws_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }
}

resource "aws_route_table_association" "aws_public_rta" {
  subnet_id      = aws_subnet.aws_public_subnet.id
  route_table_id = aws_route_table.aws_public_rt.id
}

resource "aws_route_table" "onprem_public_rt" {
  vpc_id = aws_vpc.onprem_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.onprem_igw.id
  }
}

resource "aws_route_table_association" "onprem_public_rta" {
  subnet_id      = aws_subnet.onprem_public_subnet.id
  route_table_id = aws_route_table.onprem_public_rt.id
}