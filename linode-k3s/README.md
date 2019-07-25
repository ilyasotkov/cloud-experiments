# linode-k3

```sh
docker-compose run --rm controller bash
```

```sh
cd terraform/
read -s LINODE_TOKEN
export LINODE_TOKEN
```
```sh
terraform init
terraform apply -auto-approve
```

```sh
cd ../ansible
```
```sh
read -s ANSIBLE_VAULT_PASSWORD
export ANSIBLE_VAULT_PASSWORD
```
```sh
ansible-playbook provision.yml --tags linux
```
In `inventory.yml`:
```diff
all:
  vars:
    # Change the below after running `ansible-playbook provision.yml` for the first time
-    ansible_user: root
+    ansible_user: deploy
+    ansible_become: yes
```
```sh
ansible-playbook provision.yml --tags wg,k3s
```

```sh
ansible-playbook apps.yml
```
