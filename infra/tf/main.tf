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

module "diff_data_website" {
  source  = "./modules/diff_data_website_core"
  website_domain_name = var.website_domain_name
}

module "route53_domain_name_servers" {
  source  = "ScottG489/helpers/aws//modules/route53_domain_name_servers"
  route53_zone_name = module.diff_data_website.r53_zone_name
  route53_zone_name_servers = module.diff_data_website.r53_zone_name_servers
}