provider "aws" {
  region = "us-west-2"
}

module "helpers_s3_website" {
  source  = "ScottG489/helpers/aws//modules/s3_website"
  version = "0.1.8"
  name = var.website_domain_name
  subdomain_redirect_protocol = "https"
}

resource "aws_route53_zone" "r53_zone" {
  name = var.website_domain_name
}

module "helpers_s3_website_route53_records" {
  source = "ScottG489/helpers/aws//modules/s3_website_route53_records"
  version = "0.1.8"
  route53_zone_id = aws_route53_zone.r53_zone.id
  s3_website_hosted_zone_id = aws_cloudfront_distribution.cloudfront_dist.hosted_zone_id
  s3_website_record_alias_name = aws_cloudfront_distribution.cloudfront_dist.domain_name
}

resource "aws_cloudfront_distribution" "cloudfront_dist" {
  default_root_object            = "index.html"
  enabled                        = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD",]
    cached_methods   = ["GET", "HEAD"]
    // CachingOptimized
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = module.helpers_s3_website.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = module.helpers_s3_website.bucket_regional_domain_name
    origin_id = module.helpers_s3_website.bucket_regional_domain_name
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
