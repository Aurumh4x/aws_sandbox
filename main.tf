module "sandbox" {
  source             				      = "./aws_sandbox"
  sandbox_owner_name              = "Owner"
  sandbox_user_name               = "User"
  inbound_vpn_cidr				        = ["1.2.3.4/32"]
  vpc_cidr                        = "10.0.0.0/16"
}

provider "aws" {
  region = "us-west-2"
}