

output "elb_name" {
  value = "${split("-", data.kubernetes_service.my-service.status.0.load_balancer.0.ingress.0.hostname)[0]}"
}

output "elb_host" {
  value = "${data.kubernetes_service.my-service.status.0.load_balancer.0.ingress.0.hostname}"
}