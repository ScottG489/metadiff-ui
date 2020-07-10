#!/bin/bash
set -e

get_git_root_dir() {
  echo -n "$(git rev-parse --show-toplevel)"
}

setup_credentials() {
  set +x
  local ID_RSA_CONTENTS
  local AWS_CREDENTIALS_CONTENTS
  readonly ID_RSA_CONTENTS=$(echo -n $1 | jq -r .ID_RSA | base64 --decode)
  readonly AWS_CREDENTIALS_CONTENTS=$(echo -n $1 | jq -r .AWS_CREDENTIALS | base64 --decode)

  printf -- "$ID_RSA_CONTENTS" >/root/.ssh/id_rsa
  printf -- "$AWS_CREDENTIALS_CONTENTS" >/root/.aws/credentials

  chmod 400 /root/.ssh/id_rsa
}

build_package_application() {
  local ROOT_DIR
  readonly ROOT_DIR=$(get_git_root_dir)
  cd "$ROOT_DIR"

  npm install

  # Build and package front-end
  CI=true npm run test
  npm run build
}

tf_backend_init() {
  local ROOT_DIR
  local TFSTATE_BACKEND_BUCKET_NAME

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly TFSTATE_BACKEND_BUCKET_NAME=$1

  cd "$ROOT_DIR/infra/tf/backend-init"

  # Initialize terraform backend on first deploy
  aws s3 ls "$TFSTATE_BACKEND_BUCKET_NAME" &&
    (terraform init &&
      terraform import aws_s3_bucket.backend_bucket "$TFSTATE_BACKEND_BUCKET_NAME")
  terraform init
  terraform plan
  terraform apply --auto-approve
}

tf_apply() {
  local ROOT_DIR
  local RELATIVE_PATH_TO_TF_DIR

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly RELATIVE_PATH_TO_TF_DIR=$1

  cd "$ROOT_DIR/$RELATIVE_PATH_TO_TF_DIR"

  terraform init
  terraform plan
  terraform apply --auto-approve
}

setup_nameservers() {
  local ROOT_DIR
  local DOMAIN_NAME

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly DOMAIN_NAME=$1

  cd "$ROOT_DIR/infra/tf"

  # Terraform can't manage domains. This gets the nameservers off the hosted zone and sets them as the nameservers for the domain
  NS1=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[0]')
  NS2=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[1]')
  NS3=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[2]')
  NS4=$(terraform show --json | jq --raw-output '.values.root_module.resources[] | select(.address == "aws_route53_zone.website_r53_zone") | .values.name_servers[3]')
  aws --region us-east-1 route53domains update-domain-nameservers --domain-name "$DOMAIN_NAME" --nameservers Name="$NS1" Name="$NS2" Name="$NS3" Name="$NS4"
}

ui_deploy() {
  local ROOT_DIR
  local DOMAIN_NAME

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly DOMAIN_NAME=$1

  cd "$ROOT_DIR"

  aws s3 sync build/ s3://"$DOMAIN_NAME"
}
