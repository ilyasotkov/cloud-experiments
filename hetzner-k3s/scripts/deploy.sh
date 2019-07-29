#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@
trap cleanup EXIT
export TF_IN_AUTOMATION=1

cd ./terraform
terraform_init $env
terraform apply -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

ansible_inventory_path=/tmp/inventory.json
./ansible/inventory.py > $ansible_inventory_path
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook ./ansible/provision.yml --inventory $ansible_inventory_path
