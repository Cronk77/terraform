output "vpc_id" {
  value = aws_vpc.this.id
}
output "private_subnets" {
  value = [for subnet in aws_subnet.private: subnet.id]
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public: subnet.id]
}

output "private_route_table_id" {
  value = aws_route_table.main.id
}
