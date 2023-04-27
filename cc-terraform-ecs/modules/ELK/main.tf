# https://www.youtube.com/watch?v=trFW03zP7Uw&t=148s
# https://gist.github.com/iMilnb/27726a5004c0d4dc3dba3de01c65c575

resource "aws_elasticsearch_domain" "elastic_domain" {
  domain_name           = "cc-elastic_domain"
  elasticsearch_version = "7.10"
  cluster_config {
    instance_type = "r5.large.elasticsearch"
  }
  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 30
  }
  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.aws_region}:${var.account_id}:domain/${aws_elasticsearch_domain.elastic_domain.domain_name}/*"
    }
  ]
}
POLICY

  snapshot_options {
    automated_snapshot_start_hour = 0
  }

  tags = {
    Environment = "dev"
  }
}




resource "aws_iam_role" "lambda_elasticsearch_execution_role" {
  name = "lambda_elasticsearch_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_elasticsearch_execution_policy" {
  name = "lambda_elasticsearch_execution_policy"
  role = "${aws_iam_role.lambda_elasticsearch_execution_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "es:ESHttpPost",
      "Resource": "arn:aws:es:*:*:*"
    }
  ]
}
EOF
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./modules/ELK/cwl2es.js"
  output_path = "cwl2eslambda.zip"
}

resource "aws_lambda_function" "cwl_stream_lambda" {
  filename         = "cwl2eslambda.zip"
  function_name    = "LogsToElasticsearch"
  role             = "${aws_iam_role.lambda_elasticsearch_execution_role.arn}"
  handler          = "cwl2es.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs16.x"

  environment {
    variables = {
      es_endpoint = "${var.es_endpoint}"
    }
  }
}

resource "aws_lambda_permission" "cloudwatch_allow" {
  statement_id = "cloudwatch_allow"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.cwl_stream_lambda.arn}"
  principal = "${var.cwl_endpoint}"
  source_arn = "arn:aws:logs:us-east-2:${account_id}:log-group:${log_name}:*"
  # source_arn = "arn:aws:logs:us-east-2:${account_id}:log-group:account-microservice-logs:*"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_logs_to_es" {
  depends_on = ["aws_lambda_permission.cloudwatch_allow"]
  name            = "cloudwatch_logs_to_elasticsearch"
  # log_group_name  = "account-microservice-logs"
  log_group_name  = ${log_name}
  filter_pattern  = ["message"]
  destination_arn = "${aws_lambda_function.cwl_stream_lambda.arn}"
}