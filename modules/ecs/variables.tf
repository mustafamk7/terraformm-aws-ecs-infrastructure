variable "app_name" {
  description = "Application name"
  default     = "node-backend"
}

variable "cluster_name" {
  description = "Name of the ECS Cluster"
  default     = "node-backend-cluster"
}

variable "image_url" {
  description = "ECR Image URL"
  default     = "783764614265.dkr.ecr.us-east-1.amazonaws.com/node-backend:latest"
}


variable "subnets" {
  description = "Subnets for ECS services"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for ECS services"
  type        = string
}
