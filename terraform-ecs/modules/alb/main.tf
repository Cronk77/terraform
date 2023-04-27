# alb

resource "aws_alb" "alb" {
  name               = "${var.app_name}-alb-${var.version_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_security_group.id]
}

resource "aws_security_group" "alb_security_group" {
  name        = "${var.app_name}-alb-sg-${var.version_name}"
  vpc_id      = var.vpc_id

  ingress {
      from_port   = var.ingress_from_port
      to_port     = var.ingress_to_port
      cidr_blocks = var.ingress_cidr_blocks
      protocol    = var.ingress_protocol
  }

  egress {
      from_port   = var.egress_from_port
      to_port     = var.egress_to_port
      cidr_blocks = var.egress_cidr_blocks
      protocol    = var.egress_protocol
  }
}