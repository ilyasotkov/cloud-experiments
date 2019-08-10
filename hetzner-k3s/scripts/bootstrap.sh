#!/usr/bin/env bash

set -eux
cd $(dirname $0)/..
source ./scripts/includes.sh
setup $@

cd ./ansible
ansible-playbook bootstrap.yml --extra-vars env=$env
