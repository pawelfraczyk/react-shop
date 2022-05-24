resource "aws_ecs_cluster" "backend" {
  name = "${local.stack_name}-backend-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "backend" {
  name            = "${local.stack_name}-backend-ecs-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_backend.arn
    container_name   = "api"
    container_port   = 2370
  }

  network_configuration {
    subnets         = data.terraform_remote_state.shared_remote_state.outputs.aws_vpc_private_subnets
    security_groups = [aws_security_group.backend_ecs.id]
  }

}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${local.stack_name}-backend-ecs-task-def"
  execution_role_arn       = aws_iam_role.backend_task_execution.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "api",
    "image": "088302454178.dkr.ecr.eu-west-1.amazonaws.com/react-shop-shared-eu-west-1-api:latest",
    "cpu": 512,
    "memory": 1024,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 2370,
        "hostPort": 2370
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.backend_ecs.name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "api"
      }
    }
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}