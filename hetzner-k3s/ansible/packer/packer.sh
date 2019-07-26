#!/bin/bash

set -eux
cd $(dirname $0)/..

cat ./packer/packer.yaml | yq . | packer build -
