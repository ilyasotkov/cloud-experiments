FROM alpine:3.10

RUN apk --update add \
        sudo \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git \
        bash \
        apache2-utils \
        curl

WORKDIR /project

ARG TERRAFORM_VERSION=0.12.5
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip
