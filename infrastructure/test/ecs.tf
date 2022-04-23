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
  task_definition = aws_ecs_task_definition.backend.arn # TODO
  desired_count   = 2
  #   iam_role        = aws_iam_role.foo.arn #TODO
  #   depends_on      = [aws_iam_role_policy.foo] #TODO

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_backend.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets         = ["subnet-001a21c5490e5a70b", "subnet-014bac4c4d73a2218", "subnet-014bac4c4d73a2218"]
    security_groups = [aws_security_group.backend_ecs.id]
  }

}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${local.stack_name}-backend-ecs-task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "nginx",
    "image": "nginx:latest",
    "cpu": 512,
    "memory": 1024,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}