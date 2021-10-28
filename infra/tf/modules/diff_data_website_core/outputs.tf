output "bucket" {
  value = module.helpers_s3_website.bucket_name
}

output "bucket_website_endpoint" {
  value = module.helpers_s3_website.website_endpoint
}

output "r53_zone_name" {
  value = aws_route53_zone.r53_zone.name
}

output "r53_zone_id" {
  value = aws_route53_zone.r53_zone.id
}

output "r53_zone_name_servers" {
  value = aws_route53_zone.r53_zone.name_servers
}

output "cf_dist_domain_name" {
  value = aws_cloudfront_distribution.cloudfront_dist.domain_name
}
