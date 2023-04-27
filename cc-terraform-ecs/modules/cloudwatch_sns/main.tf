# Cloud Watch ALARM for low CPU utilization for each microservice
resource "aws_cloudwatch_metric_alarm" "service_low_cpu" {
  count                     = length(var.app_services)
  alarm_name                = "${var.app_services[count.index]}_service_low_CPU"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"# was 5
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "10"
  alarm_description         = "This metric monitors ${var.app_services[count.index]} service cpu utilization"
  actions_enabled           = "true"
  insufficient_data_actions = []
  dimensions = {
    ClusterName = "${var.ecs_cluster_name}"
    ServiceName = "cc-${var.app_services[count.index]}-microservice-Service"
  }
}

# Event rule for tracking low cpu alarms on ECS within cloud watch 
resource "aws_cloudwatch_event_rule" "ecs_low_utilization_cpu" {
  name          = "ecs_low_utilization_CPU"
  description   = "Capture ECS task low cpu utilization"

  event_pattern = <<EOF
{
  "source": [
    "aws.cloudwatch"
  ],
  "detail-type": [
    "CloudWatch Alarm State Change"
  ],
  "resources": [
    "arn:aws:cloudwatch:${var.aws_region}:${var.account_id}:alarm:account_service_low_CPU",
    "arn:aws:cloudwatch:${var.aws_region}:${var.account_id}:alarm:bank_service_low_CPU",
    "arn:aws:cloudwatch:${var.aws_region}:${var.account_id}:alarm:card_service_low_CPU",
    "arn:aws:cloudwatch:${var.aws_region}:${var.account_id}:alarm:transaction_service_low_CPU",
    "arn:aws:cloudwatch:${var.aws_region}:${var.account_id}:alarm:underwriter_service_low_CPU",
    "arn:aws:cloudwatch:${var.aws_region}:${var.account_id}:alarm:user_service_low_CPU"
  ],
  "detail": {
        "state": {
            "value": [
                "ALARM"
            ]
        }
    }
}
EOF
}
#############       LAMBDA     ###########################################################################
# Target invoke lambda function
resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.ecs_low_utilization_cpu.name
  target_id = "invokeLambda"
  arn       = "arn:aws:lambda:${var.aws_region}:${var.account_id}:function:cc-tf-destroy"
}

resource "aws_lambda_permission" "ecs_low_cpu_permission" {
  statement_id  = "AllowExecutionFromECSLowCPUEventRule"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_low_utilization_cpu.arn
}

resource "aws_lambda_function" "lambda_function" {
  s3_bucket     = "cc-aline-ecs-bucket"
  s3_key        = "cc-tf-destroy.py"
  function_name = "cc-tf-destroy"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "cc-tf-destroy.lambda_handler"
  runtime       = "python3.9"
  architectures = ["x86_64"]
  layers        = ["arn:aws:lambda:us-east-2:239153380322:layer:mylayer:1"]
}

resource "aws_s3_bucket_object" "object" {
  bucket = "cc-aline-ecs-bucket"
  key    = "cc-tf-destroy.py"
  source = "../LambdaFunc/cc-tf-destroy.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../LambdaFunc/cc-tf-destroy.zip")
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "s3:*"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

##############     SNS     ################################################################
# Target SNS as where to send the event rule notification
resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.ecs_low_utilization_cpu.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.ecs_low_cpu.arn
}

resource "aws_sns_topic" "ecs_low_cpu" {
  name = "ecs_low_cpu"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.ecs_low_cpu.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.ecs_low_cpu.arn]
  }
}

