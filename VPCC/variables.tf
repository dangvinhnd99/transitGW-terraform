variable "vpc_cidr_3" {
  type        = string
  description = "This configures the vpc cidr"
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
