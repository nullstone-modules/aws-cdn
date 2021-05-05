resource "aws_route53_record" "domain-root" {
  provider = aws.domain

  count = local.has_domain ? 1 : 0

  zone_id = data.ns_connection.domain.outputs.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "domain-www" {
  provider = aws.domain

  count = local.has_domain && var.enable_www ? 1 : 0

  zone_id = data.ns_connection.domain.outputs.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "subdomain-root" {
  count = local.has_subdomain ? 1 : 0

  zone_id = data.ns_connection.subdomain.outputs.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "subdomain-www" {
  count = local.has_subdomain && var.enable_www ? 1 : 0

  zone_id = data.ns_connection.subdomain.outputs.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}

locals {
  main_subdomain = local.has_domain ? try(data.ns_connection.domain.outputs.fqdn, "") : try(data.ns_connection.subdomain.outputs.fqdn, "")
  main_zone_id   = local.has_domain ? try(data.ns_connection.domain.outputs.zone_id, "") : try(data.ns_connection.subdomain.outputs.zone_id, "")
  alt_subdomains = var.enable_www ? ["www.${local.main_subdomain}"] : []
  all_subdomains = flatten([[local.main_subdomain], local.alt_subdomains])
}
