#!/bin/bash
set -ex

source /opt/build/build_functions.sh

set +x
setup_credentials "$1"
set -x

declare -r _PROJECT_NAME='diff-info-service-ui'
declare -r _GIT_REPO='git@github.com:ScottG489/diff-info-service-ui.git'
# Used for the domain name but also the s3 bucket (AWS requires them to be the same)
declare -r _DOMAIN_NAME='diff-data.com'
declare -r _TFSTATE_BUCKET_NAME='tfstate-diff-data.com'

git clone $_GIT_REPO
cd $_PROJECT_NAME

build_package_application

tf_backend_init $_TFSTATE_BUCKET_NAME

tf_apply "infra/tf"

ui_deploy $_DOMAIN_NAME

# Acceptance testing. Currently running against prod but once we have multiple environments this will point elsewhere
npx cypress run