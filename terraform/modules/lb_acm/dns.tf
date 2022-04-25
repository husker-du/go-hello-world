# Access the load balancer through a route53 domain
# Get already, publicly configured Hosted Zone on Route53 - MUST EXIST
data "aws_route53_zone" "dns" {
  name = var.dns_name
}

#Create Alias record towards ALB from Route53
resource "aws_route53_record" "alias" {
  #for_each = var.alias_names
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = data.aws_route53_zone.dns.name
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
