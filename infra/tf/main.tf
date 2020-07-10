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

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket_name
  acl    = "public-read"
  policy = templatefile("policy-template.json.tmpl", { bucket_name: var.website_bucket_name })
  force_destroy = true

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "www_website_bucket" {
    bucket                      = var.www_website_bucket_name

    website {
        redirect_all_requests_to = aws_s3_bucket.website_bucket.bucket
    }
}

resource "aws_route53_zone" "website_r53_zone" {
    name         = var.website_r53_zone_name
}

resource "aws_route53_record" "website_r53_record_A_top" {
    zone_id = aws_route53_zone.website_r53_zone.id
    name    = ""
    type    = "A"

    alias {
        zone_id                = aws_s3_bucket.website_bucket.hosted_zone_id
        name                   = "s3-website-us-west-2.amazonaws.com"
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "website_record_A_www" {
    zone_id = aws_route53_zone.website_r53_zone.id
    name    = "www"
    type    = "A"

    alias {
        zone_id                = aws_s3_bucket.www_website_bucket.hosted_zone_id
        name                   = "s3-website-us-west-2.amazonaws.com"
        evaluate_target_health = false
    }
}
