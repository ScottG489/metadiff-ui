output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

output "website_endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}

output "website_hosted_zone_id" {
  value = aws_s3_bucket.www_website_bucket.hosted_zone_id
}

output "www_website_endpoint" {
  value = aws_s3_bucket.www_website_bucket.hosted_zone_id
}