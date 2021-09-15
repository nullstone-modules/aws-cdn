variable "app_metadata" {
  description = <<EOF
App Metadata is injected from the app on-the-fly.
This contains information about resources created in the app module that are needed by the capability.
EOF

  type    = map(string)
  default = {}
}

variable "index" {
  type        = string
  description = "The default document to use when hitting the root of the site."
  default     = "index.html"
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
