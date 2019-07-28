#!/usr/bin/env python

from __future__ import print_function
import yaml, json
import os

terraform_path = os.path.join(os.path.dirname(__file__), "../terraform")
current_directory = os.getcwd()
os.chdir(terraform_path)
terraform_output_json = os.popen('terraform output -json').read()
os.chdir(current_directory)

terraform_output = json.loads(terraform_output_json)
node_domain_names = terraform_output["node_domain_names"]["value"]

inventory = {
  "ungrouped": {
    "hosts": {
      "localhost": {
        "local_path": "/project",
        "ansible_connection": "local",
        "controller_ssh_key_comment": "hcloud-k3s"
      }
    }
  },
  "harden_linux": {
    "hosts": {}
  },
  "all": {
    "hosts": {},
    "vars": {
      "ansible_ssh_private_key_file": "/project/.ssh/id_rsa",
      "ansible_become": True,
      "ansible_python_interpreter": "/usr/bin/python",
      "python_version": 2,
      "ansible_user": "admin"
    }
  },
  "k3s_cluster": {
    "children": {
      "nodes": {
        "hosts": {}
      },
      "masters": {
        "hosts": {}
      }
    },
    "vars": {
      "k3s_version": "v0.7.0",
      "systemd_dir": "/etc/systemd/system",
      "master_ip": "{{ hostvars[groups['masters'][0]].ansible_ens10.ipv4.address }}"
    }
  }
}

for index, node_domain_name in enumerate(node_domain_names):
    if index == 0:
        inventory_hostname = "master"
        inventory["all"]["hosts"][inventory_hostname] = {
            "ansible_host": node_domain_name
        }
        inventory["harden_linux"]["hosts"][inventory_hostname] = {}
        inventory["k3s_cluster"]["children"]["masters"]["hosts"][inventory_hostname] = {}
    else:
        inventory_hostname = "node{}".format(index)
        inventory["all"]["hosts"][inventory_hostname] = {
            "ansible_host": node_domain_name
        }
        inventory["harden_linux"]["hosts"][inventory_hostname] = {}
        inventory["k3s_cluster"]["children"]["nodes"]["hosts"][inventory_hostname] = {}

print(json.dumps(inventory, indent=2))
