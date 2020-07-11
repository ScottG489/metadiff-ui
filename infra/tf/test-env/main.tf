provider "aws" {
  region = "us-west-2"
}

module "s3_website" {
  source = "../modules/s3_website"
  name = "${random_id.domain_name_prefix.hex}.com"
}

module "s3_website_route53_zone" {
  source = "../modules/s3_website_route53_zone"
  name = module.s3_website.bucket_name
  s3_website_hosted_zone_id = module.s3_website.website_hosted_zone_id
}

resource "random_id" "domain_name_prefix" {
  byte_length = 4
  prefix = "${var.website_domain_name_prefix}-"
}
