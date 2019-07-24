#!/bin/bash

set -eux

cat buildfile.yaml | yq . | packer build -var-file values.json -
