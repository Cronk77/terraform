resource "kubernetes_secret" "aline-secret" {
  metadata {
    name      = "aline-secret"
    namespace = "default"
  }
  data = {
    ENCRYPT_SECRET_KEY = var.encrypt_secret_key
    JWT_SECRET_KEY = var.jwt_secret_key
    DB_USERNAME  = var.db_user_name
    DB_PASSWORD  = random_password.db_master_pass.result
  }
  type = "Opaque"
}