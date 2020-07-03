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

resource "aws_s3_bucket" "diff_data_com_bucket" {
  bucket = "diff-data.com"
  acl    = "public-read"
  policy = file("policy.json")
  force_destroy = true

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "www_diff_data_com_bucket" {
    bucket                      = "www.diff-data.com"

    website {
        redirect_all_requests_to = "diff-data.com"
    }
}

resource "aws_route53_zone" "diff_data_com_r53_zone" {
    name         = "diff-data.com."
}

resource "aws_route53_record" "diff_data_com_r53_record_A_top" {
    zone_id = aws_route53_zone.diff_data_com_r53_zone.id
    name    = ""
    type    = "A"

    alias {
        zone_id                = aws_s3_bucket.diff_data_com_bucket.hosted_zone_id
        name                   = "s3-website-us-west-2.amazonaws.com"
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "diff_data_com_r53_record_A_www" {
    zone_id = aws_route53_zone.diff_data_com_r53_zone.id
    name    = "www"
    type    = "A"

    alias {
        zone_id                = aws_s3_bucket.www_diff_data_com_bucket.hosted_zone_id
        name                   = "s3-website-us-west-2.amazonaws.com"
        evaluate_target_health = false
    }
}
