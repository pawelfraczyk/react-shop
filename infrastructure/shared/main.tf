locals {
  stack_name = "${var.project}-${var.environment}-${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "react-shop-infrastructure"
    key            = "infrastructure/shared/eu-west-1/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "react-shop-tf-locks"
  }
}