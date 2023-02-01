# Web Server Security Group
resource "aws_security_group" "VPC2_web_sg" {
  name        = "VPC2_web_sg"
  description = "VPC2_web_sg"
  vpc_id      = aws_vpc.vpc2.id

  # HTTP/S and SSH from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
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
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
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

# Create Ubuntu Instance on a private subnet
resource "aws_instance" "VPC2_web1" {
  ami                         = "ami-0aa7d40eeae50c9a9"
  instance_type               = "t2.micro"
  private_ip                  = "10.10.1.20"
  subnet_id                   = aws_subnet.private_data_subnet_az1.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.VPC2_web_sg.id]
  associate_public_ip_address = false
  //user_data                   = filebase64("/home/vinh/Documents/transitGW-terraform/VPCB/VPC2_userdata_web.sh")
  tags = {
    Name = "VPC2_Web_Server_1"
  }
}
