# Create a certificate and set its validation method to use DNS
resource "aws_acm_certificate" "ssl_cert" {
  domain_name               = data.aws_route53_zone.dns.name
  subject_alternative_names = [ "*.${data.aws_route53_zone.dns.name}" ]
  validation_method         = "DNS"
  tags                      = var.config.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Wait for the newly created certificate to become valid
resource "aws_acm_certificate_validation" "validation" {
  for_each                = aws_route53_record.validation
  certificate_arn         = aws_acm_certificate.ssl_cert.arn
  validation_record_fqdns = [aws_route53_record.validation[each.key].fqdn]
}

# Validate the certificate against the domain name to confirm the domain ownership
# Create records in hosted zone for ACM Certificate Domain verification
resource "aws_route53_record" "validation" {
  for_each = {
    for val in aws_acm_certificate.ssl_cert.domain_validation_options : val.domain_name => {
      name   = val.resource_record_name
      record = val.resource_record_value
      type   = val.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  zone_id         = data.aws_route53_zone.dns.zone_id
  ttl             = "60"
}

