resource "aws_s3_bucket" "website_bucket" {
  bucket = var.name
  acl    = "public-read"
  policy = templatefile("${path.module}/policy-template.json", { bucket_name: var.name })
  force_destroy = true

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket" "www_website_bucket" {
    bucket = "www.${var.name}"

    website {
        redirect_all_requests_to = aws_s3_bucket.website_bucket.bucket
    }
}
