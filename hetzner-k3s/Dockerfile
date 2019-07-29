FROM alpine:3.10

WORKDIR /project

ARG ANSIBLE_VERSION=2.8.1
RUN apk --update add \
                sudo \
                python3 \
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
                python3-dev \
                libffi-dev \
                openssl-dev \
                build-base \
        && pip3 install --quiet --upgrade \
                pip \
                cffi \
                pywinrm \
                jmespath \
                yq \
        && pip3 install --quiet ansible==${ANSIBLE_VERSION} \
        && apk del build-dependencies \
        && rm -rf /var/cache/apk/* \
        && mkdir -p /etc/ansible \
        && echo localhost > /etc/ansible/hosts

ARG TERRAFORM_VERSION=0.12.5
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

ARG K3S_VERSION=0.7.0
RUN curl -L -o ./k3s \
        https://github.com/rancher/k3s/releases/download/v${K3S_VERSION}/k3s \
        && chmod +x ./k3s \
        && mv k3s /usr/bin

ARG PACKER_VERSION=1.4.2
RUN curl -L -o packer.zip \
        https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
        && unzip packer.zip \
        && chmod +x packer \
        && mv packer /usr/bin \
        && rm -f packer.zip \
        && packer version

ARG HETZNER_CLI_VERSION=1.13.0
RUN curl -L -o hcloud.tar.gz \
        https://github.com/hetznercloud/cli/releases/download/v${HETZNER_CLI_VERSION}/hcloud-linux-amd64-v${HETZNER_CLI_VERSION}.tar.gz \
        && tar -xvzf hcloud.tar.gz \
        && rm -rf hcloud.tar.gz \
        && mv hcloud-linux-amd64-v${HETZNER_CLI_VERSION}/bin/hcloud /usr/bin \
        && chmod 0700 /usr/bin/hcloud

ARG TASKFILE_VERSION=2.6.0
RUN curl -L -o task.tar.gz \
        https://github.com/go-task/task/releases/download/v${TASKFILE_VERSION}/task_linux_amd64.tar.gz \
        && tar -xvzf task.tar.gz \
        && rm -rf task.tar.gz \
        && mv task /usr/bin \
        && chmod 0700 /usr/bin/task

COPY . .
