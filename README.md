# cloud-experiments

Experimenting with modern cloud tech. Building cool serverless platforms using free open-source software and cheap but powerful cloud infrastructure from minor cloud providers.

## Subprojects

### hetzner-swarm

A [docker/swarm](https://github.com/docker/swarm) cluster on Hetzner Cloud

- Infrastructure setup with Terraform (Hetzner Cloud Networks and Servers, CloudFlare DNS)
- Docker Swarm cluster provisioned idempotently via Ansible (dynamic inventory from Terraform outputs)
- Applications:
    - Traefik as cluster ingress controller (reverse proxy)
    - EFK logging stack (Fluent Bit -> Elasticsearch -> Kibana)
    - A minimal nginx-app to test zero-downtime updates on Docker Swarm (even with 1 service replica!)
    - A Docker registry to host custom containers
    - `test-apps/flask-app` as an example of hosting a custom application

Project-specific notes and details: [hetzner-swarm/README.md](hetzner-swarm/README.md)

### hetzner-k3s

A [rancher/k3s](https://github.com/rancher/k3s) cluster on Hetzner Cloud

- Infrastructure setup with Terraform (Hetzner Cloud Networks and Servers, CloudFlare DNS)
- k3s cluster provisioned with Ansible (dynamic inventory from Terraform outputs)
- Kubernetes resources provisioned with [Helmfile](https://github.com/roboll/helmfile)
    - MetalLB to create LoadBalancer service for the ingress controller
    - Nginx-ingress as cluster ingress-controller (Traefik to be evaluated as alternative)
    - cert-manager and external-dns with CloudFlare integration
    - Persistent Volume provisioning via [hetznercloud/csi-driver](https://github.com/hetznercloud/csi-driver)

### test-apps/flask-app

An example custom application used for containerization

### linode-swarm

⚠️ Needs work

[docker/swarm](https://github.com/docker/swarm) cluster on Linode with Terraform and Ansible

### linode-k3s

⚠️ Needs work

[rancher/k3s](https://github.com/rancher/k3s) cluster on Linode with Terraform and Ansible
