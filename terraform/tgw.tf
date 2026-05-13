# Transit Gateway for inter-VPC routing
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway for VPCs"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "aws_vpc_attachment" {
  subnet_ids         = [aws_subnet.aws_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.aws_vpc.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "onprem_vpc_attachment" {
  subnet_ids         = [aws_subnet.onprem_private_subnet.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.onprem_vpc.id
}