# Site-to-Site VPN between AWS and On-Prem
resource "aws_customer_gateway" "onprem_cgw" {
  bgp_asn    = 65000
  ip_address = aws_instance.onprem_vpn_server.public_ip
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "aws_to_onprem" {
  vpn_gateway_id      = aws_vpn_gateway.aws_vgw.id
  customer_gateway_id = aws_customer_gateway.onprem_cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
}

# VPN Gateway for AWS VPC
resource "aws_vpn_gateway" "aws_vgw" {
  vpc_id = aws_vpc.aws_vpc.id
}