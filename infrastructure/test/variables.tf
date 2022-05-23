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