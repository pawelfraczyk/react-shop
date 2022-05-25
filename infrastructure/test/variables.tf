variable "project" {
  type        = string
  default     = "react-shop"
  description = "Name of the project"
}

variable "environment" {
  type        = string
  default     = "test"
  description = "Name of the environment"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "Name of the AWS Region"
}

variable "domain" {
  type        = string
  default     = "react.devops.codes"
  description = "Domain for Cloudfront Frontend"
}

variable "api_image" {
  type        = string
  default     = "088302454178.dkr.ecr.eu-west-1.amazonaws.com/react-shop-shared-eu-west-1-api:20-0f46dd6"
  description = "Name of ECR image for api"
}