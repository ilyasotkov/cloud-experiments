#!/usr/bin/env python3

import json
import subprocess


def main():
    terraform_output = capture_terraform_output(terraform_directory='../terraform')
    ansible_inventory = generate_ansible_inventory(terraform_output, ansible_inventory_base)
    print(json.dumps(ansible_inventory, indent=2))


def ansible_inventory_base():
    return {
        '_meta': {
            'hostvars': {
                'localhost': {
                  'local_path': '/project',
                  'ansible_connection': 'local',
                  'controller_ssh_key_comment': 'hcloud-k8s-{{ env }}',
                  'bootstrap_ssh_key_name': 'id_rsa_{{ env }}'
                }
            }
        },
        'all': {
            'children': [
                'ungrouped',
                'host-security',
                'etcd',
                'k8s-cluster',
                'kube-master',
                'kube-node',
                'calico-rr'
            ],
            'hosts': [],
            'vars': {
                'cluster_name': 'k8s-{{ env }}.flexp.live'
            }
        },
        'ungrouped': {
            'children': [],
            'hosts': ['localhost'],
            'vars': {}
        },
        'k8s-cluster': {
            'children': ['kube-master', 'kube-node', 'calico-rr'],
            'hosts': [],
            'vars': {}
        },
        'host-security': {
            'hosts': [],
            'vars': {}
        },
        'kube-master': {
            'hosts': [],
            'vars': {}
        },
        'kube-node': {
            'hosts': [],
            'vars': {}
        },
        'etcd': {
            'hosts': [],
            'vars': {}
        },
        'calico-rr': {
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
        node_public_ips = terraform_output['node_public_ips']['value']
        node_domain_names = terraform_output['node_domain_names']['value']
        node_private_ips = terraform_output['node_private_ips']['value']

        ansible_inventory['all']['vars']['environment_type'] = environment_type

        for index, node_public_ip in enumerate(node_public_ips):
            inventory_hostname = node_domain_names[index]
            ansible_inventory['_meta']['hostvars'][inventory_hostname] = {
                'ansible_host': node_public_ip,
                'ip': node_private_ips[index],
                'access_ip': node_private_ips[index]
            }
            if inventory_hostname.startswith('master'):
                ansible_inventory['kube-node']['hosts'].append(inventory_hostname)
                ansible_inventory['kube-master']['hosts'].append(inventory_hostname)
                ansible_inventory['etcd']['hosts'].append(inventory_hostname)
                ansible_inventory['all']['hosts'].append(inventory_hostname)
            else:
                ansible_inventory['kube-node']['hosts'].append(inventory_hostname)
                ansible_inventory['all']['hosts'].append(inventory_hostname)

    return ansible_inventory


main()
