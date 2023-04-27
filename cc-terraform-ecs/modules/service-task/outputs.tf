output "account_task_def" {
  value = "${aws_ecs_task_definition.account_task_definition.id}"
}

output "bank_task_def" {
  value = "${aws_ecs_task_definition.bank_task_definition.id}"
}

output "card_task_def" {
  value = "${aws_ecs_task_definition.card_task_definition.id}"
}

output "transaction_task_def" {
  value = "${aws_ecs_task_definition.transaction_task_definition.id}"
}

output "underwriter_task_def" {
  value = "${aws_ecs_task_definition.underwriter_task_definition.id}"
}

output "user_task_def" {
  value = "${aws_ecs_task_definition.user_task_definition.id}"
}