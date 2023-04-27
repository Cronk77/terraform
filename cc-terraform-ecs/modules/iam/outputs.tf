# iam/outputs.tf

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_role_name" {
  value = aws_iam_role.ecs_task_execution_role.name
}