wget --content-on-error -nv -O - --post-data '{"ID_RSA": "'"$1"'", "AWS_CREDENTIALS": "'"$2"'"}' 'http://simple-ci.com/build?image=scottg489/diff-info-service-ui-build:latest'
