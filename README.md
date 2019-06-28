# Diff Info Service UI

## Building and deploying
You will need valid credentials to clone the repository and to deploy to AWS on S3

Here is an example of how to run after you've build the image
```bash
ID_RSA_CONTENTS_BASE64=$(base64 id_rsa) ;                                                 <<<
AWS_CREDENTIALS_CONTENTS_BASE64=$(base64 credentials) ;
curl --data-binary '{"ID_RSA": "'"$ID_RSA_CONTENTS_BASE64"'", "AWS_CREDENTIALS": "'"$AWS_CREDENTIALS_CONTENTS_BASE64"'"}' 'https://<DOCKER CI INSTANCE URL>/build?image=scottg489/diff-info-service-ui-build:latest'
```
