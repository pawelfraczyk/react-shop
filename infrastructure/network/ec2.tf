### Monitoring & Logging tools ###
resource "aws_instance" "tools" {
  ami                  = data.aws_ami.amazon2-ami.id
  instance_type        = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.ec2-tools-profile.id

  user_data = file("${path.module}/templates/init.sh")

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.tools-sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 60
    tags = merge(map(
      "Name", "${var.project}-${var.environment}-ec2-tools-vol"
    ), var.default_tags)
  }

  tags = merge(map(
    "Name", "${var.project}-${var.environment}-ec2-tools"
  ), var.default_tags)

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "tools" {
  instance = aws_instance.tools.id
  vpc      = true
}

### Security Group ###
resource "aws_security_group" "tools-sg" {
  name        = "${var.project}-tools-sg"
  description = "Allows traffic to ec2 tools."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 12201
    to_port   = 12201
    protocol  = "udp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-ec2-tools-sg"
    Project     = var.project
    Environment = var.environment
    Terraform   = true
  }
}

# Set default EBS encryption to the region
resource "aws_ebs_encryption_by_default" "encryption" {
  enabled = true
}