locals {
  aws_region_azs = formatlist("${var.region}%s", ["a", "b", "c"])
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = local.stack_name
  cidr = "10.0.0.0/16"

  azs              = local.aws_region_azs
  private_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  database_subnets = ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]

  enable_nat_gateway   = false
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}