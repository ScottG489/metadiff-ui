#!/bin/bash
set -ex

source /home/build-user/build/build_functions.sh

set +x
setup_credentials "$1"
set -x

declare -r _PROJECT_NAME='metadiff-ui'
declare -r _GIT_REPO='git@github.com:ScottG489/metadiff-ui.git'
# Used for the domain name but also the s3 bucket (AWS requires them to be the same)
declare -r _TFSTATE_BUCKET_NAME='tfstate-metadiff.com'
declare -r _RUN_TASK=$(echo -n $1 | jq -r .RUN_TASK)
declare -r _GIT_BRANCH=$(echo -n $1 | jq -r .GIT_BRANCH)

git clone --branch $_GIT_BRANCH $_GIT_REPO
cd $_PROJECT_NAME

build_package_application

/home/build-user/build/run-test.sh

if [ "$_RUN_TASK" != "deploy" ]; then exit 0; fi
tf_backend_init $_TFSTATE_BUCKET_NAME

tf_apply "infra/tf"

ui_deploy "infra/tf"
