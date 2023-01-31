variable "vpc_cidr_1" {
  type        = string
  description = "This configures the vpc cidr"
}
variable "private_subnet1_az1_cidr" {
  type        = string
  description = "This configures the public subnet1 cidr"
}
variable "private_subnet1_az2_cidr" {
  type        = string
  description = "This configures the public subnet1 cidr"
}
variable "ubuntu_20_ami_sg" {
  type        = string
  description = "This configures the public subnet1 cidr"
}
variable "region" {
  type = string
}
variable "aws_ec2_transit_gateway" {
  type = string
}
variable "key_name" {
  type = string
}
