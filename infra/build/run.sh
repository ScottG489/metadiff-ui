#!/bin/bash
set -ex

source $HOME/build/build_functions.sh

set +x
setup_credentials "$1"
set -x

declare -r _PROJECT_NAME='metadiff-ui'
declare -r _GIT_REPO='git@github.com:ScottG489/metadiff-ui.git'
# Used for the domain name but also the s3 bucket (AWS requires them to be the same)
declare -r _TFSTATE_BUCKET_NAME='tfstate-metadiff.com'
declare -r _RUN_TASK=$(jq -r .RUN_TASK <<< "$1")
declare -r _GIT_BRANCH=$(jq -r .GIT_BRANCH <<< "$1")

git clone --branch $_GIT_BRANCH $_GIT_REPO
cd $_PROJECT_NAME

build_package_application

$HOME/build/run-test.sh

[ "$_RUN_TASK" != "deploy" ] && exit 0
tf_backend_init $_TFSTATE_BUCKET_NAME

tf_apply "infra/tf"

ui_deploy "infra/tf"
