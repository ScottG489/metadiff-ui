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

module "s3_website" {
  source = "./modules/s3_website"
  name = var.website_domain_name
}

module "s3_website_route53_zone" {
  source = "./modules/s3_website_route53_zone"
  name = module.s3_website.bucket_name
  s3_website_hosted_zone_id = module.s3_website.website_hosted_zone_id
}

module "route53_domain_name_servers" {
  source = "./modules/route53_domain_name_servers"
  route53_zone_name = module.s3_website_route53_zone.name
  route53_zone_name_servers = module.s3_website_route53_zone.nameservers
}