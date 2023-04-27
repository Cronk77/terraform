output "alb_name" {
  value = "${aws_alb.alb.id}"
}

output "alb_sg_id" {
  value = "${aws_security_group.alb_security_group.id}"
}

output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_alb.alb.zone_id
}
