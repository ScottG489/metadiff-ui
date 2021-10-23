provider "aws" {
  region = "us-west-2"
}
provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}

module "helpers_s3_website" {
  source  = "ScottG489/helpers/aws//modules/s3_website"
  version = "0.1.7"
  name = var.website_name
  subdomain_redirect_protocol = "https"
}

//resource "aws_s3_bucket" "website_bucket" {
//  bucket = var.website_name
//  acl    = "public-read"
//  policy = templatefile("${path.module}/policy-template.json", { bucket_name: var.website_name })
//  force_destroy = true
//
//  website {
//    index_document = "index.html"
//  }
//}
//
//resource "aws_s3_bucket" "www_website_bucket" {
//  bucket = "www.${var.website_name}"
//
//  website {
//    redirect_all_requests_to = "https://${aws_s3_bucket.website_bucket.bucket}"
//  }
//}

resource "aws_route53_zone" "r53_zone" {
  name = var.website_name
}

resource "aws_route53_record" "website_r53_record_A_top" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = ""
  type    = "A"

  alias {
    zone_id                = aws_cloudfront_distribution.cfdist.hosted_zone_id
    name                   = aws_cloudfront_distribution.cfdist.domain_name
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "website_r53_record_AAAA_top" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = ""
  type    = "AAAA"

  alias {
    zone_id                = aws_cloudfront_distribution.cfdist.hosted_zone_id
    name                   = aws_cloudfront_distribution.cfdist.domain_name
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_record_A_www" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = "www"
  type    = "A"

  alias {
    zone_id                = aws_cloudfront_distribution.cfdist.hosted_zone_id
    name                   = aws_cloudfront_distribution.cfdist.domain_name
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_record_AAAA_www" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = "www"
  type    = "AAAA"

  alias {
    zone_id                = aws_cloudfront_distribution.cfdist.hosted_zone_id
    name                   = aws_cloudfront_distribution.cfdist.domain_name
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "cfdist" {
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