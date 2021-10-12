FROM ubuntu:20.04

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  npm \
  awscli \
  jq \
  curl \
  unzip \
  # Required for Cypress
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb

RUN curl https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip -o /tmp/terraform.zip && \
  unzip -d /usr/local/bin /tmp/terraform.zip && \
  rm /tmp/terraform.zip

# Necessary due to "Error: write after end" bug. Remove once this has been fixed (seems to be issue with npm)
RUN npm install -g npm

RUN useradd -m -u 1000 -s /usr/bin/bash build-user
USER build-user

RUN mkdir /home/build-user/.ssh
COPY known_hosts /home/build-user/.ssh/known_hosts

RUN mkdir /home/build-user/.aws
COPY config /home/build-user/.aws/config

RUN mkdir -p /home/build-user/build
COPY run.sh /home/build-user/build/run.sh
COPY run-test.sh /home/build-user/build/run-test.sh
COPY build_functions.sh /home/build-user/build/build_functions.sh

WORKDIR /home/build-user/build
ENTRYPOINT ["./run.sh"]
