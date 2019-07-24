FROM alpine:3.9

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
                jq \
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
                linode-cli \
                yq \
        && pip install --quiet ansible==2.8.1 \
        && apk del build-dependencies \
        && rm -rf /var/cache/apk/* \
        && mkdir -p /etc/ansible \
        && echo localhost > /etc/ansible/hosts

WORKDIR /project
RUN curl -L -o packer.zip \
        https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip \
        && unzip packer.zip \
        && chmod +x packer \
        && mv packer /usr/bin \
        && rm -f packer.zip \
        && packer version
