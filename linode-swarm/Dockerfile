FROM alpine:3.6

RUN apk --update add \
                sudo \
                python \
                py-pip \
                openssl \
                ca-certificates \
                sshpass \
                openssh-client \
                rsync \
                git \
                bash \
                apache2-utils \
                curl \
        && apk --update add --virtual build-dependencies \
                python-dev \
                libffi-dev \
                openssl-dev \
                build-base \
        && pip install --quiet --upgrade \
                pip \
                cffi \
                pywinrm \
                jmespath \
        && pip install --quiet ansible==2.8.1 \
        && apk del build-dependencies \
        && rm -rf /var/cache/apk/* \
        && mkdir -p /etc/ansible \
        && echo localhost > /etc/ansible/hosts

WORKDIR /linode-swarm
ARG ANSIBLE_VAULT_PASSWORD

ARG TERRAFORM_VERSION=0.12.3
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

COPY ansible/requirements.yml ./ansible/
RUN ansible-galaxy install -r ./ansible/requirements.yml
COPY . .
