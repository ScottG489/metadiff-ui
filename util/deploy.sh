#!/bin/bash
set -e

ID_RSA_PATH=$1
AWS_CREDENTIALS_PATH=$2

ID_RSA_CONTENTS_BASE64=$(base64 $ID_RSA_PATH) ; AWS_CREDENTIALS_CONTENTS_BASE64=$(base64 $AWS_CREDENTIALS_PATH) ; curl -v --data-binary '{"ID_RSA": "'"$ID_RSA_CONTENTS_BASE64"'", "AWS_CREDENTIALS": "'"$AWS_CREDENTIALS_CONTENTS_BASE64"'"}' 'docker-ci-prototype.us-west-2.elasticbeanstalk.com/build?image=scottg489/diff-info-service-ui-build:latest'
