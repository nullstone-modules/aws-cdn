output "cdn_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "string ||| CloudFront Distribution ARN"
}

output "cert_arn" {
  value       = aws_acm_certificate.this.arn
  description = "string ||| SSL Certificate ARN"
}
