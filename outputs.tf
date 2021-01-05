output "cdn_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "string ||| CloudFront Distribution ARN"
}

output "cert_arn" {
  value       = local.cert_arn
  description = "string ||| SSL Certificate ARN"
}
