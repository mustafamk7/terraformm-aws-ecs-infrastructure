resource "aws_ecr_repository" "node_backend" {
  name = var.app_name
}
