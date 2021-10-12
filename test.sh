#!/bin/bash
set -ex

declare ID_RSA_CONTENTS_BASE64
declare DOCKER_CONFIG_CONTENTS_BASE64
declare AWS_CREDENTIALS_CONTENTS_BASE64
declare MAINKEYPAIR_CONTENTS_BASE64
declare TWILIO_ACCOUNT_SID
declare TWILIO_API_KEY
declare TWILIO_API_SECRET
declare TWILIO_CHAT_SERVICE_SID
declare AWS_ACCESS_KEY_ID
declare AWS_SECRET_ACCESS_KEY
# Change the location of these files based on where they are on your system
ID_RSA_CONTENTS_BASE64=$(base64 ~/.ssh/id_rsa | tr -d '\n') ;
DOCKER_CONFIG_CONTENTS_BASE64=$(base64 ~/.docker/config.json | tr -d '\n') ;
AWS_CREDENTIALS_CONTENTS_BASE64=$(base64 ~/.aws/credentials | tr -d '\n') ;
MAINKEYPAIR_CONTENTS_BASE64=$(base64 ~/.ssh/mainkeypair.pem | tr -d '\n') ;
#TWILIO_ACCOUNT_SID=
#TWILIO_API_KEY=
#TWILIO_API_SECRET=
#TWILIO_CHAT_SERVICE_SID=
#AWS_ACCESS_KEY_ID=
#AWS_SECRET_ACCESS_KEY=

[[ -n $ID_RSA_CONTENTS_BASE64 ]]
[[ -n $DOCKER_CONFIG_CONTENTS_BASE64 ]]
[[ -n $AWS_CREDENTIALS_CONTENTS_BASE64 ]]
[[ -n $MAINKEYPAIR_CONTENTS_BASE64 ]]
[[ -n $TWILIO_ACCOUNT_SID ]]
[[ -n $TWILIO_API_KEY ]]
[[ -n $TWILIO_API_SECRET ]]
[[ -n $TWILIO_CHAT_SERVICE_SID ]]
[[ -n $AWS_ACCESS_KEY_ID ]]
[[ -n $AWS_SECRET_ACCESS_KEY ]]

read -r -d '\' JSON_BODY <<- EOM
  {
  "ID_RSA": "$ID_RSA_CONTENTS_BASE64",
  "DOCKER_CONFIG": "$DOCKER_CONFIG_CONTENTS_BASE64",
  "AWS_CREDENTIALS": "$AWS_CREDENTIALS_CONTENTS_BASE64",
  "MAIN_KEY_PAIR": "$MAINKEYPAIR_CONTENTS_BASE64",
  "TWILIO_ACCOUNT_SID": "$TWILIO_ACCOUNT_SID",
  "TWILIO_API_KEY": "$TWILIO_API_KEY",
  "TWILIO_API_SECRET": "$TWILIO_API_SECRET",
  "TWILIO_CHAT_SERVICE_SID": "$TWILIO_CHAT_SERVICE_SID",
  "AWS_ACCESS_KEY_ID": "$AWS_ACCESS_KEY_ID",
  "AWS_SECRET_ACCESS_KEY": "$AWS_SECRET_ACCESS_KEY"
  }\\
EOM

# The local fs is mounted into the container and as such any files it writes will have their permissions changed.
#   This will change the permissions back and clean up other files we don't want hanging around.
sudo chown -R "$(whoami)":"$(whoami)" -- * .*
find . -name '*terraform.tfstate*' -exec rm {} \;
find . -name '.terraform' -type d -prune -exec rm -rf {} \;

docker build infra/build -t app-test && \
docker run -it \
  --runtime=sysbox-runc \
  --volume "$PWD:/home/build-user/build/metadiff-ui" \
  app-test "$JSON_BODY"
