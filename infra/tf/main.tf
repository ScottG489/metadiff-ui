provider "aws" {
  region = "us-west-2"
}
provider "aws" {
  region = "us-east-1"
  alias = "us_east_1"
}

terraform {
  backend "s3" {
    bucket = "tfstate-metadiff.com"
    key    = "metadiff.com.tfstate"
    region = "us-west-2"
  }
}

module "diff_data_website" {
  source  = "./modules/diff_data_website_core"
  website_domain_name = var.website_domain_name
  cf_hosted_zone_id = aws_cloudfront_distribution.cloudfront_dist.hosted_zone_id
  cf_domain_name = aws_cloudfront_distribution.cloudfront_dist.domain_name
}

module "route53_domain_name_servers" {
  source  = "ScottG489/helpers/aws//modules/route53_domain_name_servers"
  route53_zone_name = module.diff_data_website.r53_zone_name
  route53_zone_name_servers = module.diff_data_website.r53_zone_name_servers
}

resource "aws_cloudfront_distribution" "cloudfront_dist" {
  // We must wait for the certificate to be valid before creating the CF distribution
  depends_on = [
    aws_acm_certificate_validation.cert_validation
  ]
  default_root_object            = "index.html"
  enabled                        = true
  is_ipv6_enabled     = true

  aliases  = [
    var.website_domain_name,
    "www.${var.website_domain_name}"
  ]

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
      acm_certificate_arn            = aws_acm_certificate.acm_cert.arn
      cloudfront_default_certificate = false
      minimum_protocol_version       = "TLSv1.2_2021"
      ssl_support_method             = "sni-only"
    }
}

resource "aws_acm_certificate" "acm_cert" {
  // Certs used with CF need to be in us-east-1
  provider = aws.us_east_1
  domain_name = var.website_domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "www.${var.website_domain_name}"
  ]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.us_east_1
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_r53_record_cname : record.fqdn]
}

resource "aws_route53_record" "cert_validation_r53_record_cname" {
  zone_id = module.diff_data_website.r53_zone_id
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60

  for_each = {
  for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }
}
