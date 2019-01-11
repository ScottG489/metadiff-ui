#!/bin/bash
ID_RSA_CONTENTS=$1
AWS_CREDENTIALS_CONTENTS=$2

printf -- "$ID_RSA_CONTENTS" > /root/.ssh/id_rsa
printf -- "$AWS_CREDENTIALS_CONTENTS" > /root/.aws/credentials

chmod 400 /root/.ssh/id_rsa

git clone git@github.com:ScottG489/diff-info-service-ui.git
cd diff-info-service-ui
npm install
npm run build
aws s3 sync build/ s3://diff-info-service-ui --acl public-read
