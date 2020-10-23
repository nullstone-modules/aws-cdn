data "terraform_remote_state" "subdomain" {
  backend = "pg"

  workspace = length(split(".", var.parent_blocks.subdomain)) == 3 ? replace(var.parent_blocks.subdomain, ".", "-") : "${var.stack_name}-${var.env}-${var.parent_blocks.subdomain}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}
