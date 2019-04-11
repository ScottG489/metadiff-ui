#!/bin/bash
set -e

ID_RSA_CONTENTS=$(echo -n $1 | jq -r .ID_RSA | base64 --decode)
AWS_CREDENTIALS_CONTENTS=$(echo -n $1 | jq -r .AWS_CREDENTIALS | base64 --decode)

printf -- "$ID_RSA_CONTENTS" > /root/.ssh/id_rsa
printf -- "$AWS_CREDENTIALS_CONTENTS" > /root/.aws/credentials

chmod 400 /root/.ssh/id_rsa

git clone git@github.com:ScottG489/diff-info-service-ui.git
cd diff-info-service-ui
npm install
npm run build

# Only need to run first time. Is there a more elegant way to do this?
aws s3 mb s3://diff-info-service-ui || true
aws s3 website s3://diff-info-service-ui --index-document index.html

aws s3 sync build/ s3://diff-info-service-ui --acl public-read
