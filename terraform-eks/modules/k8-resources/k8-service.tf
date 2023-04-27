# resource "kubernetes_service" "microservice_service" {
#   count = length(var.microservices)
#   metadata {
#     name = "${var.microservices[count.index]}-service"
#   }
#   spec {
#     selector = {
#       app = "${var.microservices[count.index]}-deployment"
#     }
#     port {
#       port = var.microservice_ports[count.index]
#     }
#   }
# }


########  ACOUNT  ###########
resource "kubernetes_service" "account_service" {
  metadata {
    name = "account-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.account_deployment.metadata.0.labels.app
    }
    # session_affinity = "ClientIP"
    port {
      port = 8176
    #   target_port = 80
    }
    # type = "NodePort"
  }
}

########  BANK  ###########
resource "kubernetes_service" "bank_service" {
  metadata {
    name = "bank-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.bank_deployment.metadata.0.labels.app
    }
    # session_affinity = "ClientIP"
    port {
      port = 8172
    #   target_port = 80
    }
    # type = "NodePort"
  }
}

########  CARD  ###########
resource "kubernetes_service" "card_service" {
  metadata {
    name = "card-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.card_deployment.metadata.0.labels.app
    }
    # session_affinity = "ClientIP"
    port {
      port = 8174
    #   target_port = 80
    }
    # type = "NodePort"
  }
}

########  TRANSACTION  ###########
resource "kubernetes_service" "transaction_service" {
  metadata {
    name = "transaction-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.transaction_deployment.metadata.0.labels.app
    }
    # session_affinity = "ClientIP"
    port {
      port = 8178
    #   target_port = 80
    }
    # type = "NodePort"
  }
}

########  UNDERWRITER  ###########
resource "kubernetes_service" "underwriter_service" {
  metadata {
    name = "underwriter-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.underwriter_deployment.metadata.0.labels.app
    }
    # session_affinity = "ClientIP"
    port {
      port = 8170
    #   target_port = 80
    }
    # type = "NodePort"
  }
}

########  USER  ###########
resource "kubernetes_service" "user_service" {
  metadata {
    name = "user-service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.user_deployment.metadata.0.labels.app
    }
    # session_affinity = "ClientIP"
    port {
      port = 8177
    #   target_port = 80
    }
    # type = "NodePort"
  }
}

