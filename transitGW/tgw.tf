#Create TGW
resource "aws_ec2_transit_gateway" "demo_tgw" {
  description = "demo_tgw"
  tags = {
    Name = "Transit_Gateway"
  }
}
resource "aws_ec2_transit_gateway_route_table" "TGW_VPCC_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
}
resource "aws_ec2_transit_gateway_route_table" "TGW_VPCA_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
}
resource "aws_ec2_transit_gateway_route_table" "TGW_VPCB_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
}

# #association
# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpcA" {
#   transit_gateway_attachment_id  = var.aws_ec2_transit_gateway_vpcA_attachment
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGW_VPCA_route_table.id
# }
# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpcB" {
#   transit_gateway_attachment_id  = var.aws_ec2_transit_gateway_vpcB_attachment
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGW_VPCB_route_table.id
# }
# resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpcC" {
#   transit_gateway_attachment_id  = var.aws_ec2_transit_gateway_vpcC_attachment
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGW_VPCC_route_table.id
# }

# # TGW Route Table
# resource "aws_ec2_transit_gateway_route" "tgw_VPCC_route" {
#   destination_cidr_block         = "0.0.0.0./0"
#   transit_gateway_attachment_id  = var.aws_ec2_transit_gateway_vpcC_attachment
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGW_VPCC_route_table.id
# }
# resource "aws_ec2_transit_gateway_route" "tgw_VPCA_route" {
#   destination_cidr_block         = "10.20.0.0/16"
#   transit_gateway_attachment_id  = var.aws_ec2_transit_gateway_vpcA_attachment
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGW_VPCA_route_table.id
# }

# resource "aws_ec2_transit_gateway_route" "tgw_VPB_route" {
#   destination_cidr_block         = "10.20.0.0/16"
#   transit_gateway_attachment_id  = var.aws_ec2_transit_gateway_vpcB_attachment
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.TGW_VPCB_route_table.id
# }

