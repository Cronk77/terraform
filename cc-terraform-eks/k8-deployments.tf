# resource "kubernetes_deployment" "microservice_deployment" {
#   count = length(var.microservices)
#   metadata {
#     name = "${var.microservices[count.index]}-deployment"
#     labels = {
#       app = "${var.microservices[count.index]}"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "${var.microservices[count.index]}"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "${var.microservices[count.index]}"
#         }
#       }

#       spec {
#         container {
#           image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-${var.microservices[count.index]}-microservice:latest"
#           name  = "account"
          
#           port {
#             container_port = var.microservice_ports[count.index]
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }

#           env {
#               name = "ENCRYPT_SECRET_KEY"
#               value_from  {
#                 secret_key_ref  {
#                   key  = "ENCRYPT_SECRET_KEY"
#                   name = "aline-secret"
#                 }
#               }
#             }
#           env {
#             name = "JWT_SECRET_KEY"
#             value_from {
#               secret_key_ref {
#                 key  = "JWT_SECRET_KEY"
#                 name = "aline-secret"
#               }
#             }
#           }
#           env {
#             name = "DB_USERNAME"
#             value_from {
#               secret_key_ref {
#                 key  = "DB_USERNAME"
#                 name = "aline-secret"
#               }
#             }
#           }
#           env {
#             name = "DB_PASSWORD"
#             value_from {
#               secret_key_ref {
#                 key  = "DB_PASSWORD"
#                 name = "aline-secret"
#               }
#             }
#           }
#           env {
#             name = "DB_HOST"
#             value_from {
#               config_map_key_ref {
#                 key  = "DB_HOST"
#                 name = "aline-config"
#               }
#             }
#           }
#           env {
#             name = "DB_NAME"
#             value_from {
#               config_map_key_ref {
#                 key  = "DB_NAME"
#                 name = "aline-config"
#               }
#             }
#           }
#           env {
#             name = "DB_PORT"
#             value_from {
#               config_map_key_ref {
#                 key  = "DB_PORT"
#                 name = "aline-config"
#               }
#             }
#           }
#           env {
#             name  = "APP_PORT"
#             value = "${var.microservice_ports[count.index]}"
#           }
#         }
#       }
#     }
#   }
# }










#########     ACCOUNT     #########
resource "kubernetes_deployment" "account_deployment" {
  metadata {
    name = "account-deployment"
    labels = {
      app = "account"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "account"
      }
    }

    template {
      metadata {
        labels = {
          app = "account"
        }
      }

      spec {
        container {
          image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-account-microservice:latest"
          name  = "account"
          
          port {
            container_port = 8176
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          env {
              name = "ENCRYPT_SECRET_KEY"
              # value = "${var.encrypt_secret_key}"
              value_from  {
                secret_key_ref  {
                  key  = "ENCRYPT_SECRET_KEY"
                  name = "aline-secret"
                }
              }
            }
          env {
            name = "JWT_SECRET_KEY"
            # value = "${var.jwt_secret_key}"
            value_from {
              secret_key_ref {
                key  = "JWT_SECRET_KEY"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            # value = "${var.db_user_name}"
            value_from {
              secret_key_ref {
                key  = "DB_USERNAME"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            # value = "${random_password.db_master_pass.result}"
            value_from {
              secret_key_ref {
                key  = "DB_PASSWORD"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_HOST"
            # value = "${aws_db_instance.rds.address}"
            value_from {
              config_map_key_ref {
                key  = "DB_HOST"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_NAME"
            # value = "aline"
            value_from {
              config_map_key_ref {
                key  = "DB_NAME"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_PORT"
            # value = "3306"
            value_from {
              config_map_key_ref {
                key  = "DB_PORT"
                name = "aline-config"
              }
            }
          }
          env {
            name  = "APP_PORT"
            value = "8176"
          }
        }
      }
    }
  }
}

#############    BANK     ###############
resource "kubernetes_deployment" "bank_deployment" {
  metadata {
    name = "bank-deployment"
    labels = {
      app = "bank"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "bank"
      }
    }

    template {
      metadata {
        labels = {
          app = "bank"
        }
      }

      spec {
        container {
          image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-bank-microservice:latest"
          name  = "bank"
          
          port {
            container_port = 8172
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          env {
              name = "ENCRYPT_SECRET_KEY"
              # value = "${var.encrypt_secret_key}"
              value_from  {
                secret_key_ref  {
                  key  = "ENCRYPT_SECRET_KEY"
                  name = "aline-secret"
                }
              }
            }
          env {
            name = "JWT_SECRET_KEY"
            # value = "${var.jwt_secret_key}"
            value_from {
              secret_key_ref {
                key  = "JWT_SECRET_KEY"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            # value = "${var.db_user_name}"
            value_from {
              secret_key_ref {
                key  = "DB_USERNAME"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            # value = "${random_password.db_master_pass.result}"
            value_from {
              secret_key_ref {
                key  = "DB_PASSWORD"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_HOST"
            # value = "${aws_db_instance.rds.address}"
            value_from {
              config_map_key_ref {
                key  = "DB_HOST"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_NAME"
            # value = "aline"
            value_from {
              config_map_key_ref {
                key  = "DB_NAME"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_PORT"
            # value = "3306"
            value_from {
              config_map_key_ref {
                key  = "DB_PORT"
                name = "aline-config"
              }
            }
          }
          env {
            name  = "APP_PORT"
            value = "8172"
          }
        }
      }
    }
  }
}

#############    CARD     ###############
resource "kubernetes_deployment" "card_deployment" {
  metadata {
    name = "card-deployment"
    labels = {
      app = "card"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "card"
      }
    }

    template {
      metadata {
        labels = {
          app = "card"
        }
      }

      spec {
        container {
          image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-card-microservice:latest"
          name  = "card"
          
          port {
            container_port = 8174
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          env {
              name = "ENCRYPT_SECRET_KEY"
              # value = "${var.encrypt_secret_key}"
              value_from  {
                secret_key_ref  {
                  key  = "ENCRYPT_SECRET_KEY"
                  name = "aline-secret"
                }
              }
            }
          env {
            name = "JWT_SECRET_KEY"
            # value = "${var.jwt_secret_key}"
            value_from {
              secret_key_ref {
                key  = "JWT_SECRET_KEY"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            # value = "${var.db_user_name}"
            value_from {
              secret_key_ref {
                key  = "DB_USERNAME"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            # value = "${random_password.db_master_pass.result}"
            value_from {
              secret_key_ref {
                key  = "DB_PASSWORD"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_HOST"
            # value = "${aws_db_instance.rds.address}"
            value_from {
              config_map_key_ref {
                key  = "DB_HOST"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_NAME"
            # value = "aline"
            value_from {
              config_map_key_ref {
                key  = "DB_NAME"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_PORT"
            # value = "3306"
            value_from {
              config_map_key_ref {
                key  = "DB_PORT"
                name = "aline-config"
              }
            }
          }
          env {
            name  = "APP_PORT"
            value = "8174"
          }
        }
      }
    }
  }
}

#############    TRANSACTION     ###############
resource "kubernetes_deployment" "transaction_deployment" {
  metadata {
    name = "transaction-deployment"
    labels = {
      app = "transaction"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "transaction"
      }
    }

    template {
      metadata {
        labels = {
          app = "transaction"
        }
      }

      spec {
        container {
          image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-transaction-microservice:latest"
          name  = "transaction"
          
          port {
            container_port = 8178
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          env {
              name = "ENCRYPT_SECRET_KEY"
              # value = "${var.encrypt_secret_key}"
              value_from  {
                secret_key_ref  {
                  key  = "ENCRYPT_SECRET_KEY"
                  name = "aline-secret"
                }
              }
            }
          env {
            name = "JWT_SECRET_KEY"
            # value = "${var.jwt_secret_key}"
            value_from {
              secret_key_ref {
                key  = "JWT_SECRET_KEY"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            # value = "${var.db_user_name}"
            value_from {
              secret_key_ref {
                key  = "DB_USERNAME"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            # value = "${random_password.db_master_pass.result}"
            value_from {
              secret_key_ref {
                key  = "DB_PASSWORD"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_HOST"
            # value = "${aws_db_instance.rds.address}"
            value_from {
              config_map_key_ref {
                key  = "DB_HOST"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_NAME"
            # value = "aline"
            value_from {
              config_map_key_ref {
                key  = "DB_NAME"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_PORT"
            # value = "3306"
            value_from {
              config_map_key_ref {
                key  = "DB_PORT"
                name = "aline-config"
              }
            }
          }
          env {
            name  = "APP_PORT"
            value = "8178"
          }
        }
      }
    }
  }
}

#############    UNDERWRITER     ###############
resource "kubernetes_deployment" "underwriter_deployment" {
  metadata {
    name = "underwriter-deployment"
    labels = {
      app = "underwriter"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "underwriter"
      }
    }

    template {
      metadata {
        labels = {
          app = "underwriter"
        }
      }

      spec {
        container {
          image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-underwriter-microservice:latest"
          name  = "underwriter"
          
          port {
            container_port = 8170
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          env {
              name = "ENCRYPT_SECRET_KEY"
              # value = "${var.encrypt_secret_key}"
              value_from  {
                secret_key_ref  {
                  key  = "ENCRYPT_SECRET_KEY"
                  name = "aline-secret"
                }
              }
            }
          env {
            name = "JWT_SECRET_KEY"
            # value = "${var.jwt_secret_key}"
            value_from {
              secret_key_ref {
                key  = "JWT_SECRET_KEY"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            # value = "${var.db_user_name}"
            value_from {
              secret_key_ref {
                key  = "DB_USERNAME"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            # value = "${random_password.db_master_pass.result}"
            value_from {
              secret_key_ref {
                key  = "DB_PASSWORD"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_HOST"
            # value = "${aws_db_instance.rds.address}"
            value_from {
              config_map_key_ref {
                key  = "DB_HOST"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_NAME"
            # value = "aline"
            value_from {
              config_map_key_ref {
                key  = "DB_NAME"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_PORT"
            # value = "3306"
            value_from {
              config_map_key_ref {
                key  = "DB_PORT"
                name = "aline-config"
              }
            }
          }
          env {
            name  = "APP_PORT"
            value = "8170"
          }
        }
      }
    }
  }
}
#############    USER     ###############
resource "kubernetes_deployment" "user_deployment" {
  metadata {
    name = "user-deployment"
    labels = {
      app = "user"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "user"
      }
    }

    template {
      metadata {
        labels = {
          app = "user"
        }
      }

      spec {
        container {
          image = "239153380322.dkr.ecr.us-east-2.amazonaws.com/cc-user-microservice:latest"
          name  = "user"
          
          port {
            container_port = 8177
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          env {
              name = "ENCRYPT_SECRET_KEY"
              # value = "${var.encrypt_secret_key}"
              value_from  {
                secret_key_ref  {
                  key  = "ENCRYPT_SECRET_KEY"
                  name = "aline-secret"
                }
              }
            }
          env {
            name = "JWT_SECRET_KEY"
            # value = "${var.jwt_secret_key}"
            value_from {
              secret_key_ref {
                key  = "JWT_SECRET_KEY"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_USERNAME"
            # value = "${var.db_user_name}"
            value_from {
              secret_key_ref {
                key  = "DB_USERNAME"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            # value = "${random_password.db_master_pass.result}"
            value_from {
              secret_key_ref {
                key  = "DB_PASSWORD"
                name = "aline-secret"
              }
            }
          }
          env {
            name = "DB_HOST"
            # value = "${aws_db_instance.rds.address}"
            value_from {
              config_map_key_ref {
                key  = "DB_HOST"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_NAME"
            # value = "aline"
            value_from {
              config_map_key_ref {
                key  = "DB_NAME"
                name = "aline-config"
              }
            }
          }
          env {
            name = "DB_PORT"
            # value = "3306"
            value_from {
              config_map_key_ref {
                key  = "DB_PORT"
                name = "aline-config"
              }
            }
          }
          env {
            name  = "APP_PORT"
            value = "8177"
          }
        }
      }
    }
  }
}

