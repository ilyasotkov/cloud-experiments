#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@
export TF_IN_AUTOMATION=1

cd ./terraform
terraform_init $env
terraform destroy -input=false -auto-approve -var-file ./vars/$env.tfvars
