FROM ubuntu:18.10

RUN apt-get update

RUN apt-get install -y git npm
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y awscli

# Necessary due to "Error: write after end" bug. Remove once this has been fixed (seems to be issue with npm)
RUN npm install -g npm

RUN mkdir /root/.ssh
COPY known_hosts /root/.ssh/known_hosts

RUN mkdir /root/.aws
COPY config /root/.aws/config

RUN mkdir -p /opt/build
COPY build.sh /opt/build/build.sh

WORKDIR /opt/build
ENTRYPOINT ["./build.sh"]
