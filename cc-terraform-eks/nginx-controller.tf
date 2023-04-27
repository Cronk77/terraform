# TEST EXAMPLE
# module "ingress-nginx" {
#   # note update the source link with the required version
#   source     = "git::https://github.com/Noura98Houssien/simple-nginx-ingress-controller.git?ref=v0.0.1"
#   cluster_id = aws_eks_cluster.this.id
# }

resource "helm_release" "nginx-ingress-controller" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"


  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

}