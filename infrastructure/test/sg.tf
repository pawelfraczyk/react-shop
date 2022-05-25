resource "aws_security_group" "public_lb" {
  name        = "${local.stack_name}-public-lb"
  description = "Allow HTTP/HTTPS to public ALB"
  vpc_id      = data.terraform_remote_state.shared_remote_state.outputs.aws_vpc_id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "backend_ecs" {
  name        = "${local.stack_name}-backend-ecs"
  description = "Allow HTTP to backend ECS"
  vpc_id      = data.terraform_remote_state.shared_remote_state.outputs.aws_vpc_id

  ingress {
    description = "HTTP"
    from_port   = 2370
    to_port     = 2370
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "docdb" {
  name        = "${local.stack_name}-docdb"
  description = "Allow mongo connectivity"
  vpc_id      = data.terraform_remote_state.shared_remote_state.outputs.aws_vpc_id

  ingress {
    description = "Mongo"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    self        = true
  }
}