variable "owner_id" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "env" {
  type = string
}

variable "block_name" {
  type = string
}

variable "parent_blocks" {
  type = object({
    origin : string,
    domain : string,
    subdomain : string
  })

  validation {
    condition     = var.parent_blocks.domain == "" && var.parent_blocks.subdomain == ""
    error_message = "Must select domain or subdomain parent block."
  }

  validation {
    condition     = var.parent_blocks.domain != "" && var.parent_blocks.subdomain != ""
    error_message = "Cannot use *both* domain and subdomain parent block."
  }
}

variable "backend_conn_str" {
  type = string
}


variable "enable_www" {
  type        = bool
  description = "Enable/Disable creating www.<domain> DNS record in addition to <domain> DNS record for hosted site"
  default     = true
}

variable "enable_404page" {
  type        = bool
  description = "Enable/Disable custom 404 page within s3 bucket. If enabled, must provide 404.html"
  default     = false
}
