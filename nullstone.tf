terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "subdomain" {
  name = "subdomain"
  type = "subdomain/aws"
}

locals {
  tags = data.ns_workspace.this.tags

  zone_id        = data.ns_connection.subdomain.outputs.zone_id
  subdomain      = data.ns_connection.subdomain.outputs.fqdn
  alt_subdomains = var.enable_www ? ["www.${local.subdomain}"] : []
  all_subdomains = concat([local.subdomain], local.alt_subdomains)

  domain_delegator = try(data.ns_connection.subdomain.outputs.delegator, { access_key : "", secret_key : "" })
}

provider "aws" {
  access_key = local.domain_delegator.access_key
  secret_key = local.domain_delegator.secret_key

  alias = "domain"
}
