# Very Permissive Security Group
resource "aws_security_group" "edge_vpc_permissive_sg" {
  name        = "edge_vpc_permissive_sg"
  description = "edge_vpc_permissive_sg"
  vpc_id      = aws_vpc.vpc3.id

  # access from the internet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# Create Ubuntu  NAT Instance (Linux Firewall) to route north-south and east-west traffic 
resource "aws_instance" "vpc_edge_nat" {
  subnet_id                   = aws_subnet.edge_external_subnet_1a.id
  ami                         = var.ubuntu_20_ami_sg
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.edge_vpc_permissive_sg.id]
  associate_public_ip_address = true
  //user_data = file("/home/vinh/Documents/transitGW-terraform/VPCC/userdata_NATGW.sh")
  tags = {
    Name = "vpc_edge_NAT_Instance"

  }
}



# Very Permissive Security Group
resource "aws_security_group" "edge_web_sg" {
  name        = "edge_web_sg"
  description = "edge_web_sg"
  vpc_id      = aws_vpc.vpc3.id

  # HTTP/S and SSH from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    security_groups = ["${aws_security_group.edge_vpc_permissive_sg.id}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# # Create Ubuntu web server on private subnet
# resource "aws_instance" "web1" {
#   ami           = "ami-0aa7d40eeae50c9a9"
#   instance_type = "t2.micro"
#   # private_ip                  = "10.7.5.20"
#   subnet_id                   = aws_subnet.edge_web_subnet_1a.id
#   key_name                    = var.key_name
#   vpc_security_group_ids      = [aws_security_group.edge_web_sg.id]
#   associate_public_ip_address = false
#   // user_data                   = filebase64("/home/vinh/Documents/transitGW-terraform/VPCC/userdata-web.sh")
#   tags = {
#     Name = "Edge_VPC_Web_Server_1"
#   }
# }
