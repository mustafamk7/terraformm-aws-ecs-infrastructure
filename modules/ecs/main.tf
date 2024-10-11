resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}


resource "aws_cloudwatch_log_group" "node_backend_log_group" {
  name = "/ecs/${var.app_name}-backend-logs"
}


resource "aws_cloudwatch_log_group" "postgres_log_group" {
  name = "/ecs/${var.app_name}-postgres-logs"
}


resource "aws_ecs_task_definition" "node_backend" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"   
  memory                   = "1024"  

  execution_role_arn       = "arn:aws:iam::783764614265:role/ECS-Task-Execution-Role"

  container_definitions = jsonencode([
    {
      name      = var.app_name
      image     = var.image_url
      cpu       = 256              
      memory    = 512               
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.node_backend_log_group.name 
          "awslogs-region"       = "us-east-1"                                        
          "awslogs-stream-prefix" = "ecs"                                            
        }
      }
    }
  ])
}

resource "aws_ecs_service" "node_backend_service" {
  name            = var.app_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.node_backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  } 
}

resource "aws_ecs_task_definition" "postgres" {
  family                   = "${var.app_name}-postgres"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   
  memory                   = "512"  

  execution_role_arn       = "arn:aws:iam::783764614265:role/ECS-Task-Execution-Role"

  container_definitions = jsonencode([
    {
      name      = "postgres"
      image     = "postgres:latest" 
      cpu       = 256              
      memory    = 512               
      essential = true
      environment = [
        {
          name  = "POSTGRES_USER"
          value = "postgres"  
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = "root" 
        },
        {
          name  = "POSTGRES_DB"
          value = "mustafa"  
        }
      ]
      portMappings = [
        {
          containerPort = 5432 
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.postgres_log_group.name 
          "awslogs-region"       = "us-east-1"                             
          "awslogs-stream-prefix" = "ecs"                                           
        }
      }
    }
  ])
}

resource "aws_ecs_service" "postgres_service" {
  name            = "${var.app_name}-postgres"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.postgres.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = true  
  }
}
