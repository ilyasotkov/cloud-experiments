#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

# ./scripts/applications.sh dev app!=hcloud-csi destroy; sleep 10
#
# kubectl get pods --all-namespaces | grep Terminating | while read line; do
#     pod_name=$(echo $line | awk '{print $2}' ) name_space=$(echo $line | awk '{print $1}' )
#     kubectl delete pods $pod_name -n $name_space --grace-period=0 --force;
# done
#
# kubectl get pvc --all-namespaces -o=jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}' | while read line; do
#     pvc_name=$(echo $line | awk '{print $2}')
#     namespace=$(echo $line | awk '{print $1}')
#     kubectl -n $namespace delete pvc $pvc_name
# done
#
# sleep 90
# ./scripts/applications.sh dev all destroy

cd ./terraform
terraform_init $env
terraform destroy -input=false -auto-approve -var-file ./vars/$env.tfvars
cd -

rm -f kubeconfigs/$env.yaml
