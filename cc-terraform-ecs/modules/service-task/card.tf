# Card

# LOG GROUP##################################################################################################
resource "aws_cloudwatch_log_group" "log_group_card" {
  name     = "card-microservice-logs"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_stream" "card-logs-stream" {
  name           = "card-logs-stream"
  log_group_name = aws_cloudwatch_log_group.log_group_card.name
}

# TASK DEF AND SERVICE#######################################################################################
resource "aws_ecs_task_definition" "card_task_definition" {
  family                   = "${var.card_service_name}-task"
  execution_role_arn       = var.ecs_task_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.memory
  cpu                      = var.cpu

  container_definitions = jsonencode([
    {
      name         = "${var.card_service_name}-container"
      image        = "${var.account_id}.dkr.ecr.${var.card_aws_region}.amazonaws.com/${var.card_service_name}:${var.card_image_tag}"
      cpu          = var.cpu
      memory       = var.memory
      essential    = true
      portMappings = [
        {
          containerPort = var.card_port
          hostPort      = var.card_port
        }
      ]
      environment = [
        {
            "name"    = "DB_PASSWORD"
            "value"   = "${tostring(var.db_password)}"  
        },
        {
            "name"    = "DB_PORT"
            "value"   = "${tostring(var.db_port)}"  
        },
        {
            "name"    = "DB_HOST"
            "value"   = "${tostring(var.db_host)}"
        },
        {
            "name"    = "DB_NAME"
            "value"   = "${tostring(var.db_name)}"
        },
        {
            "name"    = "DB_USERNAME"
            "value"   = "${tostring(var.db_user_name)}"  
        },
        {
            "name"    = "ENCRYPT_SECRET_KEY"
            "value"   = "${tostring(var.encrypt_secret_key)}"
        },
        {
            "name"    = "JWT_SECRET_KEY"
            "value"   = "${tostring(var.jwt_secret_key)}"
        },
        {
            "name"    = "APP_PORT"
            "value"   = "${tostring(var.card_port)}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = aws_cloudwatch_log_group.log_group_card.id
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.app_name
        }
      }
    }
  ])
}

resource "aws_ecs_service" "card_service" {
  name            = "${var.card_service_name}-Service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.card_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = var.card_desired_count

  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
    security_groups  = [
      var.ecs_service_sg_id,
      var.alb_sg_id
    ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.card_alb_target_group.arn
    container_name   = "${var.card_service_name}-container"
    container_port   = var.card_port
  }
  depends_on = [aws_alb_listener.card_alb_listener]
}

# AUTOSCALING ###############################################################################################
resource "aws_appautoscaling_target" "card_service_autoscaling" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.card_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "card_ecs_policy_memory" {
  name               = "${var.card_service_name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.card_service_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.card_service_autoscaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.card_service_autoscaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.target_memory
  }
}

resource "aws_appautoscaling_policy" "card_ecs_policy_cpu" {
  name               = "${var.card_service_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.card_service_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.card_service_autoscaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.card_service_autoscaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.target_cpu
  }
}

# TARGET GROUPS AND LISTERNERS ###############################################################################
resource "aws_alb_target_group" "card_alb_target_group" {
  name = "${var.card_service_name}-tg"
  port = var.card_port
  protocol = var.alb_protocol
  target_type = "ip"
  vpc_id = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    interval            = "60"
    matcher             = "200-299"
    timeout             = "10"
    path = var.health_check_path
    protocol = var.alb_protocol
    unhealthy_threshold = "5"
  }
}

resource "aws_alb_listener" "card_alb_listener" {
  load_balancer_arn = var.alb_name
  port = var.alb_listener_port
  protocol = var.alb_listener_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No routes defined"
      status_code  = "200"
    }
  }
}

resource "aws_alb_listener_rule" "card_alb_listener_rule" {
  listener_arn = aws_alb_listener.card_alb_listener.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.card_alb_target_group.arn
  }
  condition {
    path_pattern {
      values = var.card_path_pattern
    }
  }
}
########################################################################################