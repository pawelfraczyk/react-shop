data "terraform_remote_state" "shared_remote_state" {
  backend = "s3"

  config = {
    bucket = "react-shop-infrastructure"
    key    = "infrastructure/shared/eu-west-1/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_route53_zone" "domain" {
  name         = var.domain
  private_zone = false
}