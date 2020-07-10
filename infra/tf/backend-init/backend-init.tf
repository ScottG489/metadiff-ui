provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "backend_bucket" {
  bucket = "tfstate-diff-data.com"
  force_destroy = true

  versioning {
    enabled = true
  }
}
