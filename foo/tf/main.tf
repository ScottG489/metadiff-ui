provider "aws" {
  region = "us-west-2"
}
provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}

terraform {
  backend "s3" {
    # TODO: Don't want this hardcoded but backends don't allow variables
    bucket = "tfstate-diffmeta"
    key    = "app.tfstate"
    region = "us-west-2"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy-template.json", { bucket_name: var.website_name })
  force_destroy = true

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "www_website_bucket" {
  bucket = "www.${var.website_name}"

  website {
    redirect_all_requests_to = "https://${aws_s3_bucket.website_bucket.bucket}"
  }
}

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

module "helpers_route53_domain_name_servers" {
  source  = "ScottG489/helpers/aws//modules/route53_domain_name_servers"
  version = "0.1.5"
  route53_zone_name = aws_route53_zone.r53_zone.name
  route53_zone_name_servers = aws_route53_zone.r53_zone.name_servers
}

resource "aws_cloudfront_distribution" "cfdist" {
  // Necessary to add otherwise cf creation will fail because the cert isn't valid yet
  depends_on = [
    aws_acm_certificate_validation.certval,
  ]
  aliases                        = [
    var.website_name,
    "www.${var.website_name}",
  ]
  default_root_object            = "index.html"
  enabled                        = true
  is_ipv6_enabled     = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD",]
    cached_methods   = ["GET", "HEAD"]
    // CachingOptimized
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id = aws_s3_bucket.website_bucket.bucket_regional_domain_name
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

resource "aws_acm_certificate" "cert" {
  // Certs used with CF need to be in us-east-1
  provider = aws.us_east_1
  domain_name = var.website_name
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${var.website_name}",
  ]
}

resource "aws_acm_certificate_validation" "certval" {
  provider = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_r53_record_cname : record.fqdn]
}

resource "aws_route53_record" "cert_validation_r53_record_cname" {
  zone_id = aws_route53_zone.r53_zone.id
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60

  for_each = {
  for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }
}