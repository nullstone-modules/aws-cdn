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

variable "enable_404page" {
  type        = bool
  description = "Enable/Disable custom 404 page within s3 bucket. If enabled, must provide 404.html"
  default     = false
}

variable "notfound_document" {
  type        = string
  description = "The document to use when the page is not found. By default, /404.html"
  default     = "404.html"
}
