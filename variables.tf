variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

variable "enable_www" {
  type        = bool
  description = "Enable/Disable creating www.<domain> DNS record in addition to <domain> DNS record for hosted site"
  default     = true
}

variable "default_document" {
  type        = string
  description = "The default document to use when hitting the root of the site."
  default     = "index.html"
}

variable "notfound_behavior" {
  type = object({
    enabled : bool
    spa_mode : bool
    document : string
  })

  default = {
    enabled  = true
    spa_mode = true
    document = "404.html"
  }

  description = <<EOF
This configures behavior when a file is not found.
If `spa_mode` is on, all not found errors will respond with `HTTP 200` serving `default_document`.
Otherwise, will respond with `HTTP 404` serving `document`.
EOF
}
