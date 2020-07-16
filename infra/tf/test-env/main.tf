provider "aws" {
  region = "us-west-2"
}

module "diff_data_website" {
  source  = "../modules/diff_data_website_core"
  website_domain_name = "${random_id.domain_name_prefix.hex}.com"
}

resource "random_id" "domain_name_prefix" {
  byte_length = 4
  prefix = "${var.website_domain_name_prefix}-"
}
