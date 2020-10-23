resource "aws_acm_certificate" "this" {
  domain_name               = local.main_subdomain
  validation_method         = "DNS"
  subject_alternative_names = local.alt_subdomains

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.domain

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
  zone_id         = var.parent_blocks.domain != "" ? data.terraform_remote_state.domain.outputs.zone_id : data.terraform_remote_state.subdomain.outputs.subdomain["zone_id"]
  records         = [each.value.record]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
