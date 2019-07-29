#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@
trap cleanup EXIT
export TF_IN_AUTOMATION=1

cd ./terraform
terraform_init $env
terraform plan -input=false -var-file ./vars/$env.tfvars
