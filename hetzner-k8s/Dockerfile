FROM alpine:3.10

WORKDIR /project

ARG KUBESPRAY_VERSION=2.10.4
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
        && curl -L -o kubespray.tar.gz \
                https://github.com/kubernetes-sigs/kubespray/archive/v${KUBESPRAY_VERSION}.tar.gz \
        && tar -xvzf kubespray.tar.gz \
        && mv kubespray-${KUBESPRAY_VERSION} /kubespray \
        && rm -f kubespray.tar.gz \
        && pip3 install --quiet -r /kubespray/requirements.txt \
        && apk del build-dependencies \
        && rm -rf /var/cache/apk/* \
        && mkdir -p /etc/ansible \
        && echo localhost > /etc/ansible/hosts

ARG TERRAFORM_VERSION=0.12.6
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

ARG KUBECTL_VERSION=1.14.6
RUN curl -L -o kubectl \
        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod 0700 kubectl \
        && mv kubectl /usr/bin

ARG HETZNER_CLI_VERSION=1.13.0
RUN curl -L -o hcloud.tar.gz \
        https://github.com/hetznercloud/cli/releases/download/v${HETZNER_CLI_VERSION}/hcloud-linux-amd64-v${HETZNER_CLI_VERSION}.tar.gz \
        && tar -xvzf hcloud.tar.gz \
        && rm -rf hcloud.tar.gz \
        && mv hcloud-linux-amd64-v${HETZNER_CLI_VERSION}/bin/hcloud /usr/bin \
        && chmod 0700 /usr/bin/hcloud

COPY terraform/plugins.tf /terraform-plugins/plugins.tf
RUN cd /terraform-plugins \
        && terraform init \
        && mkdir -p /root/.terraform.d/plugins \
        && cp /terraform-plugins/.terraform/plugins/linux_amd64/terraform-provider* /root/.terraform.d/plugins/ \
        && cd \
        && rm -rf /terraform-plugins

ARG HELM_VERSION=2.14.2
RUN curl -L -o helm.tar.gz \
        https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -xvzf helm.tar.gz \
        && rm -rf helm.tar.gz \
        && chmod 0700 linux-amd64/helm \
        && mv linux-amd64/helm /usr/bin \
        && helm init --client-only \
        && helm plugin install https://github.com/databus23/helm-diff --version v2.11.0+5 \
        && helm plugin install https://github.com/rimusz/helm-tiller --version v0.8.3 \
        && helm tiller install

ARG HELMFILE_VERSION=0.81.3
RUN curl -L -o helmfile \
        https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 \
        && chmod 0700 helmfile \
        && mv helmfile /usr/bin
