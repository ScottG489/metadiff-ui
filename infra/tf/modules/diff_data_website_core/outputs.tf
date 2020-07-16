output "r53_zone_name" {
  value = module.helpers_s3_website_route53_zone.name
}

output "r53_zone_name_servers" {
  value = module.helpers_s3_website_route53_zone.nameservers
}
