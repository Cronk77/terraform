output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "private_subnets" {
  value = [for subnet in aws_subnet.private_subnet: subnet.id]
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnet: subnet.id]
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}