#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

./scripts/applications.sh dev all destroy
sleep 60
kubectl -n logging delete pvc elasticsearch-master-elasticsearch-master-0

cd ./terraform
terraform_init $env
terraform destroy -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

rm -f kubeconfigs/$env.yaml
