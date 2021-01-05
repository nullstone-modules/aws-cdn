resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = data.ns_connection.origin.outputs.origin_domain_name
    origin_id   = data.ns_connection.origin.outputs.origin_id

    s3_origin_config {
      origin_access_identity = data.ns_connection.origin.outputs.origin_access_identity
    }
  }

  enabled             = true
  comment             = "Managed by Terraform"
  default_root_object = "index.html"

  aliases = local.all_subdomains

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = data.ns_connection.origin.outputs.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = local.cert_arn
    ssl_support_method  = "sni-only"
  }

  dynamic "custom_error_response" {
    for_each = var.enable_404page ? ["404.html"] : []

    content {
      error_code            = "404"
      error_caching_min_ttl = "0"
      response_code         = "404"
      response_page_path    = "404.html"
    }
  }
}
