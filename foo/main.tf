provider "aws" {
  region = "us-west-2"
}
//
//provider "aws" {
//  region = "us-east-1"
//  alias = "us_east_1"
//}
//
//resource "aws_cloudfront_distribution" "cfdist" {
//}
//resource "aws_acm_certificate" "cert" {
//  provider = aws.us_east_1
//}
//resource "aws_acm_certificate_validation" "certval" {
//}
//
//resource "aws_acm_certificate_validation" "example" {
//  certificate_arn         = "arn:aws:acm:us-east-1:119314381241:certificate/40804ae3-c773-410b-8d0b-7b69111dc55f"
//  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
//}
//
//resource "aws_route53_record" "example" {
//  for_each = {
//    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
//      name   = dvo.resource_record_name
//      record = dvo.resource_record_value
//      type   = dvo.resource_record_type
//    }
//  }
//
//  allow_overwrite = true
//  name            = each.value.name
//  records         = [each.value.record]
//  ttl             = 60
//  type            = each.value.type
//  zone_id         = aws_route53_zone.example.zone_id
//}
