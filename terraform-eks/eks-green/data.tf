data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "kubernetes_service" "ingress_nginx" {

  metadata {
    name      = "nginx-ingress-controller"
    namespace = "default"
  }
  depends_on = [
    # helm_release.nginx-ingress-controller
    module.nginx-ingress-controller
  ]
}

data "aws_secretsmanager_secret" "rds_secret" {
  name = "cc-db-pass"
}

data "aws_secretsmanager_secret_version" "rds_secret_ver" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

data "kubernetes_service" "my-service" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "default"
  }

  depends_on = [module.k8-resources, module.nginx-ingress-controller]

}
