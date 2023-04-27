# Outputs ##########################################

output "db_endpoint" {
  description = "DB endpoint address for rds created"
  # value = "${aws_db_instance.rds.address}"
  value = "${local.db_creds.password}"
  sensitive   = true
}

output "db_password" {
  description = "DB password for rds created"
  value       = local.db_creds.password
  sensitive   = true
}

output "db_username" {
  description = "DB username for rds created"
  value       = local.db_creds.username
  sensitive   = false
}

# output "db_host" {
#   description = "DB host for rds created"
#   # value       = local.db_creds.host
#   value = "${aws_db_instance.rds.endpoint}"
#   sensitive   = true
# }

output "db_vpc" {
  value = aws_vpc.db.id
}

# output "db_route_table_id" {
#   value = aws_route_table.db_route_table.id
# }