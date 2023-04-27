output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}


######## DB outputs ###############
output "db_endpoint" {
  description = "DB endpoint address for rds created"
  value = "${aws_db_instance.rds.address}"
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
  sensitive   = true
}

output "db_vpc" {
  value = aws_vpc.db.id
}

######## INGRESS NGNIX Controller##########

# output "k8s_service_ingress_elb" {
#   value=module.ingress-nginx.k8s_service_ingress_elb
# }

output "k8s_service_ingress_elb" {
  description = "External DN name of elastic load balancer"
  value       = data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname
}