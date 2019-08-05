#!/usr/bin/env python3

import json
import subprocess


def main():
    terraform_output = capture_terraform_output(terraform_directory='../terraform')
    ansible_inventory = generate_ansible_inventory(terraform_output, ansible_inventory_base)
    print(json.dumps(ansible_inventory))


def ansible_inventory_base():
    return {
        '_meta': {
            'hostvars': {
                'localhost': {
                  'local_path': '/project',
                  'ansible_connection': 'local',
                  'controller_ssh_key_comment': 'hcloud-swarm'
                }
            }
        },
        'all': {
            'children': ['ungrouped', 'cluster', 'managers', 'workers'],
            'hosts': [],
            'vars': {}
        },
        'ungrouped': {
            'children': [],
            'hosts': ['localhost']
        },
        'cluster': {
            'children': ['managers', 'workers']
        },
        'managers': {
            'hosts': [],
            'vars': {}
        },
        'workers': {
            'hosts': [],
            'vars': {}
        }
    }


def capture_terraform_output(terraform_directory):
    """Get Terraform output as JSON and load into a Python dict"""

    terraform_output_raw = subprocess.check_output(
        'terraform output -json',
        cwd=terraform_directory,
        shell=True)
    terraform_output = json.loads(terraform_output_raw)
    return terraform_output


def generate_ansible_inventory(terraform_output, ansible_inventory_base):
    """Populate Ansible inventory base with values from Terraform output"""

    ansible_inventory = ansible_inventory_base()

    if terraform_output != {}:
        environment_type = terraform_output['env']['value']
        node_ip_addresses = terraform_output['node_ip_addresses']['value']
        node_domain_names = terraform_output['node_domain_names']['value']

        ansible_inventory['all']['vars']['environment_type'] = environment_type

        for index, node_ip_address in enumerate(node_ip_addresses):
            inventory_hostname = node_domain_names[index]
            ansible_inventory['_meta']['hostvars'][inventory_hostname] = {
                'ansible_host': node_ip_address
            }

            if index == 0:
                ansible_inventory['_meta']['hostvars'][inventory_hostname]['swarm_role'] = 'leader_manager'
            else:
                ansible_inventory['_meta']['hostvars'][inventory_hostname]['swarm_role'] = 'worker'

            if inventory_hostname.startswith('manager'):
                ansible_inventory['managers']['hosts'].append(inventory_hostname)
                ansible_inventory['all']['hosts'].append(inventory_hostname)
            else:
                ansible_inventory['managers']['hosts'].append(inventory_hostname)
                ansible_inventory['all']['hosts'].append(inventory_hostname)

    return ansible_inventory


main()
