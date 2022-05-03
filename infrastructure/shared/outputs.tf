output "aws_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "aws_vpc_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "aws_vpc_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "ecr_client_url" {
  description = "URL of client Container Registry"
  value       = aws_ecr_repository.client.repository_url
}

output "ecr_api_url" {
  description = "URL of api Container Registry"
  value       = aws_ecr_repository.api.repository_url
}