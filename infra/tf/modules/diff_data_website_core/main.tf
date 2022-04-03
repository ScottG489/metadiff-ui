terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "helpers_s3_website" {
  source  = "ScottG489/helpers/aws//modules/s3_website"
  version = "1.0.2"
  name = var.website_domain_name
  subdomain_redirect_protocol = "https"
}

resource "aws_route53_zone" "r53_zone" {
  name = var.website_domain_name
}

module "helpers_s3_website_route53_records" {
  source = "ScottG489/helpers/aws//modules/s3_website_route53_records"
  version = "0.1.8"
  route53_zone_id = aws_route53_zone.r53_zone.id
  s3_website_hosted_zone_id = var.cf_hosted_zone_id
  s3_website_record_alias_name = var.cf_domain_name
}
