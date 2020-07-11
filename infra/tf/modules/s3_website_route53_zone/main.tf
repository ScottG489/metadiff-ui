resource "aws_route53_zone" "website_r53_zone" {
  name = var.name
}

resource "aws_route53_record" "website_r53_record_A_top" {
  zone_id = aws_route53_zone.website_r53_zone.id
  name    = ""
  type    = "A"

  alias {
    zone_id                = var.s3_website_hosted_zone_id
    name                   = "s3-website-us-west-2.amazonaws.com"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_record_A_www" {
  zone_id = aws_route53_zone.website_r53_zone.id
  name    = "www"
  type    = "A"

  alias {
    zone_id                = var.s3_website_hosted_zone_id
    name                   = "s3-website-us-west-2.amazonaws.com"
    evaluate_target_health = false
  }
}
