# ecs

resource "aws_ecs_cluster" "ecs_cluster" {
  name = lower("${var.app_name}-cluster")
}

# security group for containers
resource "aws_security_group" "service_security_group" {
  name = "${var.app_name}-service-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
