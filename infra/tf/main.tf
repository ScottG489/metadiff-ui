provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "tfstate-diff-data.com"
    key    = "diff-data.com.tfstate"
    region = "us-west-2"
  }
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


module "route53_domain_name_servers" {
  source  = "ScottG489/helpers/aws//modules/route53_domain_name_servers"
  route53_zone_name = module.helpers_s3_website_route53_zone.name
  route53_zone_name_servers = module.helpers_s3_website_route53_zone.nameservers
}