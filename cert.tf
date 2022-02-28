module "cert" {
  source  = "nullstone-modules/sslcert/aws"
  enabled = true

  domain = {
    name    = local.subdomain
    zone_id = local.zone_id
  }

  alternative_names = local.alt_subdomains
  tags              = local.tags

  providers = {
    aws        = aws.cert
    aws.domain = aws.domain
  }
}
