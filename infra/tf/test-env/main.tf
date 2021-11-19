provider "aws" {
  region = "us-west-2"
}
provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}

module "diff_data_website" {
  source  = "../modules/diff_data_website_core"
  website_domain_name = "${random_id.domain_name_prefix.hex}.com"
  cf_hosted_zone_id = aws_cloudfront_distribution.cloudfront_dist.hosted_zone_id
  cf_domain_name = aws_cloudfront_distribution.cloudfront_dist.domain_name
}

resource "random_id" "domain_name_prefix" {
  byte_length = 4
  prefix = "${var.website_domain_name_prefix}-"
}

resource "aws_cloudfront_distribution" "cloudfront_dist" {
  default_root_object            = "index.html"
  enabled                        = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD",]
    cached_methods   = ["GET", "HEAD"]
    // CachingDisabled
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    target_origin_id       = module.diff_data_website.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = module.diff_data_website.bucket_regional_domain_name
    origin_id = module.diff_data_website.bucket_regional_domain_name
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
