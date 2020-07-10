provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = random_id.rand_project_name.hex
  acl    = "public-read"
  policy = templatefile("policy-template.json", { bucket_name: random_id.rand_project_name.hex })
  force_destroy = true

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "www_website_bucket" {
    bucket = "www.${random_id.rand_project_name.hex}"

    website {
        redirect_all_requests_to = aws_s3_bucket.website_bucket.bucket
    }
}

resource "aws_route53_zone" "website_r53_zone" {
    name         = random_id.rand_project_name.hex
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

resource "random_id" "rand_project_name" {
  byte_length = 4
  prefix = "${var.project_name}-"
}
