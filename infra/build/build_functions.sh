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

  printf -- "$ID_RSA_CONTENTS" >/home/build-user/.ssh/id_rsa
  printf -- "$AWS_CREDENTIALS_CONTENTS" >/home/build-user/.aws/credentials

  chmod 400 /home/build-user/.ssh/id_rsa
}

build_package_application() {
  local ROOT_DIR
  readonly ROOT_DIR=$(get_git_root_dir)
  cd "$ROOT_DIR"

  set +x
  . "$NVM_DIR/nvm.sh"
  set -x
  npm ci

  # Build and package front-end
  export CI=true
  npm run lint
  npm run test
  npm run build
  unset CI
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

ui_deploy() {
  local ROOT_DIR
  local RELATIVE_PATH_TO_TF_DIR
  local BUCKET_NAME

  readonly ROOT_DIR=$(get_git_root_dir)
  readonly RELATIVE_PATH_TO_TF_DIR=$1

  cd "$ROOT_DIR/$RELATIVE_PATH_TO_TF_DIR"

  readonly BUCKET_NAME=$(terraform show --json | jq --raw-output '.values.outputs.bucket.value')
  [[ -n $BUCKET_NAME ]]

  cd "$ROOT_DIR"

  aws s3 sync --delete build/ s3://"$BUCKET_NAME"
}

run_tests() {
  local ROOT_DIR
  local RELATIVE_PATH_TO_TF_DIR
  local WEBSITE_URL
  local CYPRESS_BASE_URL

  readonly RELATIVE_PATH_TO_TF_DIR=$1
  readonly ROOT_DIR=$(get_git_root_dir)

  cd "$ROOT_DIR/$RELATIVE_PATH_TO_TF_DIR"

  readonly WEBSITE_URL=$(terraform show --json | jq --raw-output '.values.outputs.cf_dist_domain_name.value')
  [[ -n $WEBSITE_URL ]]
  readonly CYPRESS_BASE_URL="http://$WEBSITE_URL"
  export CYPRESS_BASE_URL

  cd "$ROOT_DIR"

  npx cypress run
}
