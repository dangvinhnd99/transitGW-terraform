output "NAT_public_ip" {
  value = aws_eip.NAT_EIP.public_ip
}
output "aws_ec2_transit_gateway_vpc_attachment" {
  value = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_edge.id
}
