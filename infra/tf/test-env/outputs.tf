output "bucket" {
  value = module.diff_data_website.bucket
}

output "bucket_website_endpoint" {
  value = module.diff_data_website.bucket_website_endpoint
}

output "cf_dist_domain_name" {
  value = module.diff_data_website.cf_dist_domain_name
}
