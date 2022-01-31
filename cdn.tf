locals {
  custom_404 = {
    error_code    = 404,
    response_code = 404,
    cache_ttl     = 0,
    path          = "/404.html"
  }
  custom_errors = var.enable_404page ? [local.custom_404] : []

  s3_domain_name = var.app_metadata["s3_domain_name"]
  s3_origin_id   = "S3-${var.app_metadata["s3_bucket_id"]}"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  price_class         = "PriceClass_All"
  comment             = "Managed by Terraform"
  tags                = local.tags
  aliases             = local.all_subdomains
  default_root_object = "index.html"

  viewer_certificate {
    acm_certificate_arn      = module.cert.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  origin {
    domain_name = local.s3_domain_name
    origin_id   = local.s3_origin_id

    // origin_path cannot end with a '/'
    // If app_version is '', then we want origin_path = '' (this happens upon initial provision)
    origin_path = trimsuffix("/${local.app_version}", "/")

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "custom_error_response" {
    for_each = local.custom_errors

    content {
      error_code            = custom_error_response.value["error_code"]
      error_caching_min_ttl = custom_error_response.value["cache_ttl"]
      response_code         = custom_error_response.value["response_code"]
      response_page_path    = custom_error_response.value["path"]
    }
  }
}
