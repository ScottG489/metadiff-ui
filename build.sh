curl -v -s --data-binary '{"ID_RSA": "'"$1"'", "AWS_CREDENTIALS": "'"$2"'"}' 'simple-ci.com:8080/build?image=scottg489/diff-info-service-ui-build:latest'
