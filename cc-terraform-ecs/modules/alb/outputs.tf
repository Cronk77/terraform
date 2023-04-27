output "alb_name" {
  value = "${aws_alb.alb.id}"
}

output "alb_sg_id" {
  value = "${aws_security_group.alb_security_group.id}"
}
