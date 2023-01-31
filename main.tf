module "VPCA" {
  source                   = "./VPCA"
  vpc_cidr_1               = "10.20.0.0/16"
  private_subnet1_az1_cidr = "10.20.1.0/24"
  private_subnet1_az2_cidr = "10.20.3.0/24"
  ubuntu_20_ami_sg         = "ami-0aa7d40eeae50c9a9"
  region                   = "us-east-1"
  aws_ec2_transit_gateway  = module.transitGW.aws_ec2_transit_gateway
  key_name                 = "vinhkey"
}
module "VPCB" {
  source                   = "./VPCB"
  vpc_cidr_2               = "10.10.0.0/16"
  private_subnet1_az1_cidr = "10.10.1.0/24"
  private_subnet2_az2_cidr = "10.10.3.0/24"
  ubuntu_20_ami_sg         = "ami-0aa7d40eeae50c9a9"
  region                   = "us-east-1"
  aws_ec2_transit_gateway  = module.transitGW.aws_ec2_transit_gateway
  key_name                 = "vinhkey"
}
module "VPCC" {
  source                  = "./VPCC"
  vpc_cidr_3              = "192.168.0.0/16"
  ubuntu_20_ami_sg        = "ami-0aa7d40eeae50c9a9"
  region                  = "us-east-1"
  aws_ec2_transit_gateway = module.transitGW.aws_ec2_transit_gateway
  key_name                = "vinhkey"
}
module "transitGW" {
  source                                  = "./transitGW"
  aws_ec2_transit_gateway_vpcC_attachment = module.VPCC.aws_ec2_transit_gateway_vpc_attachment
  aws_ec2_transit_gateway_vpcA_attachment = module.VPCA.aws_ec2_transit_gateway_vpc_attachment
  aws_ec2_transit_gateway_vpcB_attachment = module.VPCB.aws_ec2_transit_gateway_vpc_attachment

}
resource "aws_key_pair" "vinh_key_1" {
  key_name   = "vinhkey"
  public_key = file("~/.ssh/vinhkey.pub")
}
