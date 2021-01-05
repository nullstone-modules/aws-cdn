module "cert" {
  source = "./cert"

  domain    = local.main_subdomain
  alt_names = local.alt_subdomains
  tags      = data.ns_workspace.this.tags

  count = local.has_domain ? 1 : 0
}

locals {
  cert_arn = try(data.ns_connection.outputs.cert_arn, aws_acm_certificate.this.arn)
}
