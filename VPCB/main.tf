resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc_cidr_1
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "$vpc2"
  }
}
# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "VPC2_igw"
  }
}
# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = var.private_subnet1_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet1"
  }
}
# create public subnet az2
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = var.public_subnet2_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet2"
  }
}

# Attach  TGW to VPC_A
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_VPC_A" {
  subnet_ids         = [aws_subnet.public_subnet_az1.id]
  transit_gateway_id = aws_ec2_transit_gateway.demo_tgw.id
  vpc_id             = aws_vpc.vpc2.id
}

# Create an internal/private Route Table
resource "aws_route_table" "VPC2_prv_rt" {
  vpc_id = aws_vpc.vpc2.id
}

resource "aws_route" "vpc2_internet_access" {
  route_table_id         = aws_route_table.VPC2_prv_rt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.demo_tgw.id
}

resource "aws_route" "vpc2_edge_tgw_access" {
  route_table_id         = aws_route_table.VPC2_prv_rt.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = [aws_ec2_transit_gateway.demo_tgw.id]
}

# Route Table Associations
resource "aws_route_table_association" "VPC2_prv_sub_1a_association" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.VPC2_prv_rt.id
}

resource "aws_route_table_association" "spoke_1_prv_sub_1c_association" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.VPC2_prv_rt.id
}
