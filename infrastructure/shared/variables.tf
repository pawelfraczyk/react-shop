variable "project" {
  type        = string
  default     = "react-shop"
  description = "Name of the project"
}

variable "environment" {
  type        = string
  default     = "shared"
  description = "Name of the environment"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
  description = "Name of the AWS Region"
}