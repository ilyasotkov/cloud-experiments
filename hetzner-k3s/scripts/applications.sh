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

export KUBECONFIG=$(pwd)/kubeconfigs/$1.yaml

flags="--quiet --state-values-set masterIpAddress=$master_ip,applicationDomainZone=$application_domain_zone"

if [ $2 == all ]; then
    helmfile $flags --file ./resources/helmfile.yaml sync --concurrency=1
else
    helmfile $flags --file ./resources/helmfile.yaml --selector $2 sync --concurrency=1
fi
