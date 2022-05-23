resource "aws_route53_record" "frontend" {
  allow_overwrite = true
  name            = var.domain
  type            = "A"
  zone_id         = data.aws_route53_zone.domain.zone_id
  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  allow_overwrite = true
  name            = "backend.${var.domain}"
  type            = "A"
  zone_id         = data.aws_route53_zone.domain.zone_id
  alias {
    name                   = aws_lb.public_lb.dns_name
    zone_id                = aws_lb.public_lb.zone_id
    evaluate_target_health = true
  }
}