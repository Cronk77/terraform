data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.id
}

data "kubernetes_service" "ingress_nginx" {

  metadata {
    name      = "nginx-ingress-controller"
    namespace = "default"
  }
  depends_on = [
    helm_release.nginx-ingress-controller
  ]
}