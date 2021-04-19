provider "aws" {
  alias = "domain"
}

variable "domain" {
  description = "A domain name for which the certificate should be issued. Zone ID is used to create validation records"
  type = object({
    name : string
    zone_id : string
  })
}

variable "alt_names" {
  description = "A list of alternatives to register on the SSL Certificate."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain.name
  validation_method         = "DNS"
  subject_alternative_names = var.alt_names

  tags = var.tags
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  type            = "CNAME"
  allow_overwrite = true
  zone_id         = var.domain.zone_id
  records         = [each.value.record]
  ttl             = 60

  provider = aws.domain
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  timeouts {
    create = "5m"
  }
}

output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}
