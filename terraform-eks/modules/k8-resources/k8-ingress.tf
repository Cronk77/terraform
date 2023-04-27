resource "kubernetes_ingress_v1" "aline-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "aline-ingress"
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        ######### ACCOUNT ########
        path {
          backend {
            service {
              name = "account-service"
              port {
                number = 8176
              }
            }
          }
          path = "/accounts"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "account-service"
              port {
                number = 8176
              }
            }
          }
          path = "/members*/accounts"
          path_type = "Exact"
        }
    
        ######## BANK ########
        path {
          backend {
            service {
              name = "bank-service"
              port {
                number = 8172
              }
            }
          }
          path = "/banks"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "bank-service"
              port {
                number = 8172
              }
            }
          }
          path = "/branches"
          path_type = "Prefix"
        }

        ######### CARD ########
        path {
          backend {
            service {
              name = "card-service"
              port {
                number = 8174
              }
            }
          }
          path = "/cards"
          path_type = "Prefix"
        }

        ######### TRNASACTION ########
        path {
          backend {
            service {
              name = "transaction-service"
              port {
                number = 8178
              }
            }
          }
          path = "/transactions"
          path_type = "Prefix"
        }
    
        ######## UNDERWRITER #######
        path {
          backend {
            service {
              name = "underwriter-service"
              port {
                number = 8170
              }
            }
          }
          path = "/applicants"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "underwriter-service"
              port {
                number = 8170
              }
            }
          }
          path = "/applications"
          path_type = "Prefix"
        }

        ######## USER #######
        path {
          backend {
            service {
              name = "user-service"
              port {
                number = 8177
              }
            }
          }
          path = "/users"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "user-service"
              port {
                number = 8177
              }
            }
          }
          path = "/login"
          path_type = "Prefix"
        }
      }
    }
  }
}
