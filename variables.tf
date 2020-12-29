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
