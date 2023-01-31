resource "aws_vpc" "vpc3" {
  cidr_block = var.vpc_cidr_3
  tags = {
    Name = "vpc_trunggian"
  }
}

# Create an IGW 
resource "aws_internet_gateway" "edge_vpc_igw" {
  vpc_id = aws_vpc.vpc3.id
}


# Define a NAT subnet primary availability zone
resource "aws_subnet" "edge_external_subnet_1a" {
  vpc_id                  = aws_vpc.vpc3.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "VPC3_public_subnet_1a_ex"
  }
}

# Define a NAT subnet primary availability zone
resource "aws_subnet" "edge_internal_subnet_1a" {
  vpc_id                  = aws_vpc.vpc3.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}a"
  tags = {
    Name = "VPC3_private_Subnet_1b_internal"
  }
}

# # Define a Web server Internal subnet
# resource "aws_subnet" "edge_web_subnet_1a" {
#   vpc_id                  = aws_vpc.vpc3.id
#   cidr_block              = "192.168.4.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "${var.region}a"
#   tags = {
#     Name = "Edge_VPC_Web_Subnet_1A"
#   }
# }
#create NAT GW
resource "aws_eip" "NAT_EIP" {
  vpc = true
}

resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id     = aws_subnet.edge_external_subnet_1a.id
}

# Attach  TGW to VPC3
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_edge" {
  subnet_ids         = [aws_subnet.edge_external_subnet_1a.id]
  transit_gateway_id = var.aws_ec2_transit_gateway
  vpc_id             = aws_vpc.vpc3.id
}

# Create a Public route table

resource "aws_route_table" "edge_pub_rt" {
  vpc_id = aws_vpc.vpc3.id

  # Route to the internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edge_vpc_igw.id
  }

  route {
    cidr_block         = "10.20.0.0/16"
    transit_gateway_id = var.aws_ec2_transit_gateway
  }
  route {
    cidr_block         = "10.10.0.0/16"
    transit_gateway_id = var.aws_ec2_transit_gateway
  }
  tags = {
    Name = "Edge_VPC_Public_Route_Table"
  }
}

resource "aws_route_table_association" "edge_rt_associatio_1a" {
  subnet_id      = aws_subnet.edge_external_subnet_1a.id
  route_table_id = aws_route_table.edge_pub_rt.id
}

# Create Internal Route Table
resource "aws_route_table" "edge_internal_rt" {
  vpc_id = aws_vpc.vpc3.id
  # Route to the internet
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATGW.id
  }
  tags = {
    Name = "NAT_ROUTE"
  }
}

resource "aws_route_table_association" "nat_internal_association" {
  subnet_id      = aws_subnet.edge_internal_subnet_1a.id
  route_table_id = aws_route_table.edge_internal_rt.id
}

# resource "aws_route_table_association" "web_sub_association" {
#   subnet_id      = aws_subnet.edge_web_subnet_1a.id
#   route_table_id = aws_route_table.edge_internal_rt.id
# }

# resource "aws_route" "edge_vpc_routes" {
#   route_table_id         = aws_route_table.edge_internal_rt.id
#   destination_cidr_block = "10.0.0.0/8"
#   transit_gateway_id     = var.aws_ec2_transit_gateway
# }
