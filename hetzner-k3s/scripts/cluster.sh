#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@
trap cleanup EXIT
export TF_IN_AUTOMATION=1

# Provision infrastructure
cd ./terraform
terraform_init $env
terraform apply -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

# Create a cluster from VMs
ansible_playbook provision.yml

# Deploy applications onto the cluster
export KUBECONFIG=$(pwd)/kubeconfigs/$1.yaml
k3s kubectl apply -f ./resources/init
helm init --service-account tiller --upgrade --history-max=5 --wait

k3s kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta2/aio/deploy/recommended.yaml
./scripts/applications.sh dev all
