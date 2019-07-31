#!/usr/bin/env python3

import os
import subprocess
import json
import yaml

def main():
    terraform_output = capture_terraform_output(terraform_directory='../terraform')
    ansible_inventory = generate_ansible_inventory(terraform_output)
    print(json.dumps(ansible_inventory))


def capture_terraform_output(terraform_directory):
    """Get Terraform output and load to a Python dict"""

    terraform_output_raw = subprocess.check_output(
        'terraform output -json',
        cwd=terraform_directory,
        shell=True)
    terraform_output = json.loads(terraform_output_raw)
    return terraform_output


def generate_ansible_inventory(terraform_output):
    """Populate Ansible inventory base with values from Terraform output"""

    ansible_inventory = ansible_inventory_base()

    environment_type = terraform_output['env']['value']
    node_ip_addresses = terraform_output['node_ip_addresses']['value']
    node_domain_names = terraform_output['node_domain_names']['value']

    ansible_inventory['all']['vars']['environment_type'] = environment_type

    for index, node_ip_address in enumerate(node_ip_addresses):
        inventory_hostname = node_domain_names[index]
        ansible_inventory['_meta']['hostvars'][inventory_hostname] = {
            'ansible_host': node_ip_address
        }
        if inventory_hostname.startswith('master'):
            ansible_inventory['masters']['hosts'].append(inventory_hostname)
            ansible_inventory['all']['hosts'].append(inventory_hostname)
        else:
            ansible_inventory['workers']['hosts'].append(inventory_hostname)
            ansible_inventory['all']['hosts'].append(inventory_hostname)

    return ansible_inventory


def ansible_inventory_base():
    """Empty Ansible inventory base (template)"""

    return {
        '_meta': {
            'hostvars': {}
        },
        'all': {
            'children': ['ungrouped', 'cluster', 'masters', 'workers'],
            'hosts': [],
            'vars': {}
        },
        'ungrouped': {
            'children': []
        },
        'cluster': {
            'children': ['masters', 'workers']
        },
        'masters': {
            'hosts': [],
            'vars': {}
        },
        'workers': {
            'hosts': [],
            'vars': {}
        }
    }

main()
