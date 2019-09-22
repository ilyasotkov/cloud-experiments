#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..

install_knative() {
    kubectl apply $1 -k ./kubernetes/kustomizations/knative
}

install_knative --selector='knative.dev/crd-install=true' | true
sleep 15
install_knative --selector=''
