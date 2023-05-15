# CDN for S3 Site

Creates an AWS CloudFront Distribution (CDN) with an SSL Certificate against a subdomain created as another block.



## Inputs

- `enable_www: bool` - (Default: true) Enable/Disable creating www.<domain> DNS record 
in addition to <subdomain> DNS record for site hosted on CDN
- `enable_404page: bool` - (Default: false) Enable/Disable custom 404 page within s3 bucket. If enabled, bucket must contain 404.html.

## Outputs

- `cdn_arn: string` - CloudFront Distribution ARN
- `cert_arn: string` - SSL Certificate ARN