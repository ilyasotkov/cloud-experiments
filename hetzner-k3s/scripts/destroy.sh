#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

./scripts/applications.sh dev app!=hcloud-csi destroy
kubectl delete --all pv
sleep 60
./scripts/applications.sh dev all destroy

cd ./terraform
terraform_init $env
terraform destroy -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

rm -f kubeconfigs/$env.yaml
