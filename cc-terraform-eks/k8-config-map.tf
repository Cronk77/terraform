resource "kubernetes_config_map" "aline-config" {
  metadata {
    name = "aline-config"
  }
  data = {
    DB_HOST = "${aws_db_instance.rds.address}"
    DB_NAME = "aline" 
    DB_PORT = "3306"
  }
}