#!/usr/bin/env python3

import json
import yaml
import os

terraform_path = os.path.join(os.path.dirname(__file__), '../terraform')
project_directory = os.getcwd()
os.chdir(terraform_path)
terraform_output_json = os.popen('terraform output -json').read()
os.chdir(project_directory)

terraform_output = json.loads(terraform_output_json)
node_ids = terraform_output['node_ip_addresses']['value']
environment_type = terraform_output['env']['value']

inventory = {
  'harden_linux': {
    'hosts': {},
    'vars': {}
  },
  'all': {
    'hosts': {},
    'vars': {
        'environment_type': environment_type
    }
  },
  'k3s_cluster': {
    'children': {
      'nodes': {
        'hosts': {},
        'vars': {}
      },
      'masters': {
        'hosts': {},
        'vars': {}
      }
    }
  }
}

for index, node_id in enumerate(node_ids):
    if index == 0:
        inventory_hostname = 'master'
        inventory['all']['hosts'][inventory_hostname] = {
            'ansible_host': node_id
        }
        inventory['harden_linux']['hosts'][inventory_hostname] = {}
        inventory['k3s_cluster']['children']['masters']['hosts'][inventory_hostname] = {}
    else:
        inventory_hostname = f'node{index}'
        inventory['all']['hosts'][inventory_hostname] = {
            'ansible_host': node_id
        }
        inventory['harden_linux']['hosts'][inventory_hostname] = {}
        inventory['k3s_cluster']['children']['nodes']['hosts'][inventory_hostname] = {}

print(json.dumps(inventory, indent=2))
