module "cert" {
  source = "nullstone-modules/sslcert/aws"

  domain = {
    name    = local.main_subdomain
    zone_id = local.main_zone_id
  }

  alternative_names = local.alt_subdomains
  tags              = data.ns_workspace.this.tags
  enabled           = local.has_domain

  providers = {
    aws.domain = aws.domain
  }
}

locals {
  cert_arn = local.has_domain ? module.cert[0].certificate_arn : data.ns_connection.subdomain.outputs.cert_arn
}
