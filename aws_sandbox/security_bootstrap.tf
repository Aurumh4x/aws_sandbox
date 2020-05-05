resource "aws_iam_account_password_policy" "password_policy" {
  minimum_password_length        = 20
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 24
}

resource "aws_s3_account_public_access_block" "block_public_access" {
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_security_group" "instances" {
  name        = "Instances"
  description = "Allow intra-VPC traffic, all inbound traffic from VPN and all egress traffic"
  vpc_id      = aws_vpc.sandbox_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.inbound_vpn_cidr
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "sandbox_vpc" {
  cidr_block = var.vpc_cidr
}
