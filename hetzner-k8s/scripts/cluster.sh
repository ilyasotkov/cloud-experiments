#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

# Provision infrastructure on Hetzner Cloud
cd ./terraform
terraform_init $env
terraform apply -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

# Create a cluster from provisioned infrastructure
cd ./ansible
ansible-playbook \
--skip-tags sysctl,ufw \
--extra-vars env=$env \
cluster.yml
cd -

# Deploy applications onto the cluster
./scripts/applications.sh dev all
