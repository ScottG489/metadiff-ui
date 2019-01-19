#!/bin/bash
set -e

chmod 400 /root/.ssh/id_rsa

git clone git@github.com:ScottG489/diff-info-service-ui.git
cd diff-info-service-ui
npm install
npm run build
aws s3 sync build/ s3://diff-info-service-ui --acl public-read
