provider "aws" {
  region = "us-west-2"
}

module "helpers_s3_website" {
  source  = "ScottG489/helpers/aws//modules/s3_website"
  version = "0.0.2"
  name = "${random_id.domain_name_prefix.hex}.com"
}

module "helpers_s3_website_route53_zone" {
  source  = "ScottG489/helpers/aws//modules/s3_website_route53_zone"
  version = "0.0.2"
  name = module.helpers_s3_website.bucket_name
  s3_website_hosted_zone_id = module.helpers_s3_website.website_hosted_zone_id
}

resource "random_id" "domain_name_prefix" {
  byte_length = 4
  prefix = "${var.website_domain_name_prefix}-"
}
