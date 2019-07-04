# linode-swarm

> ⚠️ This is a work in progress

> This repository is the first part of me discovering alternatives for running extra-small containerized web applications on various cloud platforms. Linode is the first cloud platform because (as it usually happens) I already have some applications hosted on Linode.

Run containerized web applications (without HA or 100% uptime) on cheapest possible infrastructure provided by Linode.

## Prerequisites

- A host machine with Docker Desktop installed.

This has been tested only on macOS but should work on Linux and Windows with minimal changes.

## Create controller image and container with interactive shell

We won't be installing anything on our workstation and run everything from a Docker container.

```sh
docker-compose build controller && docker-compose run --rm controller bash
```

All further actions happen from within the *controller* container.

## Bootstrap SSH keypair for the controller

This repository is self-contained and 100% portable, so we must first create SSH keys for the Swarm controller. SSH private key will also live in this Git repository and will be encrypted at rest using Ansible Vault.

```sh
read -s ANSIBLE_VAULT_PASSWORD
```

Generate a long password in your password manager of choice and paste into the prompt.

```sh
export ANSIBLE_VAULT_PASSWORD
```

```sh
ansible-playbook -v bootstrap.yml
```

## Create Linode infrastructure using Terraform

```sh
read -s LINODE_TOKEN
```

Generate an API token in Linode console and save to your password manager. Paste into the prompt.

```sh
export LINODE_TOKEN
```

```sh
terraform init
terraform plan
```

```sh
terraform apply
```

## Provision the VM via Ansible and deploy all containerized applications

First, update the inventory with IP addresses of the servers you just created with Terraform.

```sh
ansible-playbook -v main.yml
```

During the execution of the playbook, we'll retire the `root` user and start using `ubuntu` user instead. To complete the installation, run the playbook again.

```sh
ansible-playbook -v main.yml
```
