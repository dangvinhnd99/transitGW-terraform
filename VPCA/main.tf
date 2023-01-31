resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr_1
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc1"
  }
}
# # create internet gateway and attach it to vpc
# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.vpc1.id

#   tags = {
#     Name = "VPC1_igw"
#   }
# }
# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.private_subnet1_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet1 vpc1"
  }
}
# create private subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.private_subnet1_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet2 vpc1"
  }
}

# Attach  TGW to VPC_1
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_VPC1" {
  subnet_ids         = [aws_subnet.private_data_subnet_az1.id]
  transit_gateway_id = var.aws_ec2_transit_gateway
  vpc_id             = aws_vpc.vpc1.id
}

# Create an internal/private Route Table
resource "aws_route_table" "VPC1_prv_rt" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route" "vpc1_internet_access" {
  route_table_id         = aws_route_table.VPC1_prv_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.aws_ec2_transit_gateway
}

resource "aws_route" "vpc1_edge_tgw_access" {
  route_table_id         = aws_route_table.VPC1_prv_rt.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = var.aws_ec2_transit_gateway
}

# Route Table Associations
resource "aws_route_table_association" "VPC1_prv_sub_1_association" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.VPC1_prv_rt.id
}

resource "aws_route_table_association" "PC1_prv_sub_2_association" {
  subnet_id      = aws_subnet.private_data_subnet_az2.id
  route_table_id = aws_route_table.VPC1_prv_rt.id
}
