resource "kubernetes_config_map" "aline-config" {
  metadata {
    name = "aline-config"
  }
  data = {
    DB_HOST = "${var.db_endpoint}"
    DB_NAME = "aline" 
    DB_PORT = "3306"
  }
}