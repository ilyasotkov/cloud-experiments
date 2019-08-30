#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

cd ./terraform
terraform output -json > /tmp/tfout.json
master_ip=$(cat /tmp/tfout.json | jq -r .node_ip_addresses.value[0])
application_domain_zone=$(cat /tmp/tfout.json | jq -r .domain_zone.value)
cd -

export KUBECONFIG="$(pwd)/kubeconfigs/$env.yaml"

flags="--state-values-set masterIpAddress=$master_ip,applicationDomainZone=$application_domain_zone"
helmfile_selector=${2:-"all"}
action=${3:-"sync"}

if [ $helmfile_selector == "all" ]; then
    helmfile $flags --file ./kubernetes/helmfile.yaml $action --concurrency=1
else
    helmfile $flags --file ./kubernetes/helmfile.yaml --selector $helmfile_selector $action --concurrency=1
fi
