# Creates a record for the hosted zone given
resource "aws_route53_record" "cluster_record" {
  zone_id = var.r53_host_zone_id 
  name    = var.r53_host_zone_name 
  type    = "A"

  alias {
    name                   = var.alb_dns_name 
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  set_identifier = var.version_name
  weighted_routing_policy {
    weight = var.weighted_percentage
  }
}