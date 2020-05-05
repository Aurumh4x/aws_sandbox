variable "sandbox_owner_name" {}
variable "sandbox_user_name" {}
variable "inbound_vpn_cidr" {}
variable "vpc_cidr" {}
data "aws_caller_identity" "current" {}
 locals {
   account_id = data.aws_caller_identity.current.account_id
 }
