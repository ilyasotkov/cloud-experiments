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

flags="--quiet --state-values-set masterIpAddress=$master_ip,applicationDomainZone=$application_domain_zone"
helmfile_selector=${2:-"all"}

if [ $helmfile_selector == "all" ]; then
    helmfile $flags --file ./kubernetes/helmfile.yaml sync --concurrency=1
else
    helmfile $flags --file ./kubernetes/helmfile.yaml --selector $helmfile_selector sync --concurrency=1
fi
