provider "aws" {
  region = "us-west-2"
}

module "helpers_s3_website" {
  source  = "ScottG489/helpers/aws//modules/s3_website"
  version = "0.0.2"
  name = var.website_domain_name
}

module "helpers_s3_website_route53_zone" {
  source  = "ScottG489/helpers/aws//modules/s3_website_route53_zone"
  version = "0.0.2"
  name = module.helpers_s3_website.bucket_name
  s3_website_hosted_zone_id = module.helpers_s3_website.website_hosted_zone_id
}
