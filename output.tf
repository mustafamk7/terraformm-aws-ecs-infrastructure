output "vpc_id" {
  description = "The ID of the VPC created"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "The list of subnet IDs created by the VPC module"
  value       = module.vpc.subnet_ids
}

output "security_group_id" {
  description = "The security group ID created by the security group module"
  value       = module.security_group.security_group_id
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository for the application"
  value       = module.ecr.ecr_repository_url
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.ecs_service_name
}

