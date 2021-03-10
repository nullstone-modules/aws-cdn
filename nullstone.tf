terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "domain" {
  name     = "domain"
  type     = "domain/aws"
  optional = true
}

data "ns_connection" "subdomain" {
  name     = "subdomain"
  type     = "subdomain/aws"
  optional = true
}

data "ns_connection" "origin" {
  name = "origin"
  type = "site/aws-s3"
}

locals {
  has_domain    = data.ns_connection.domain.workspace_id != ""
  has_subdomain = data.ns_connection.subdomain.workspace_id != ""
  zone_id       = try(data.ns_connection.domain.outputs.zone_id, data.ns_connection.subdomain.outputs.zone_id)
}

// We will need to be able to support secondary providers since the root domain
//   is typically managed in a separate account from non-production environments
provider "aws" {
  access_key = try(data.ns_connection.domain.outputs.delegator["access_key"], "")
  secret_key = try(data.ns_connection.domain.outputs.delegator["secret_key"], "")

  alias = "domain"
}
