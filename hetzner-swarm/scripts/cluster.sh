#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@
export TF_IN_AUTOMATION=1

# Provision infrastructure on Hetzner Cloud
cd ./terraform
terraform_init $env
terraform apply -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

# Create a cluster from provisioned infrastructure
cd ./ansible; ansible-playbook cluster.yml; cd -
