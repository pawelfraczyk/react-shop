resource "aws_lb" "public_lb" {
  name               = "${local.stack_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_lb.id, aws_security_group.backend_ecs.id]
  subnets            = ["subnet-0704258d68dc892ea", "subnet-05f7b6c870dc3bf4c", "subnet-08073f8b5715ceacc"]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "public_lb_http" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_backend.arn
  }
}

resource "aws_lb_target_group" "ecs_backend" {
  name        = "${local.stack_name}-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-02d20e49f1950a3fa"
}