# k3s cluster on Hetzner Cloud


## Directory structure

- `scripts`: automation scripts for invoking tasks
- `terraform`: infrastructure code for creating nodes, networks, and DNS for nodes
- `ansible`: code for provisioning or upgrading nodes in a cluster
- `kubernetes`: path with Helmfile manifests
- `ssh_pubkeys`: public keys for SSHing into nodes

## Prerequisites

- Docker Desktop on local workstation
- CloudFlare account (free plan)
- Hetzner Cloud account

## Start an interactive development session

```sh
export ENV=dev
```
```sh
docker-compose build && docker-compose run --rm controller bash
```

## Create an SSH keypair

```sh
./scripts/bootstrap.sh dev
```

## Deploy whole cluster and all apps

```sh
export CLOUDFLARE_EMAIL=
export CLOUDFLARE_TOKEN=
export HCLOUD_TOKEN=
```

```sh
./scripts/cluster.sh $ENV
```

where `$ENV` can be one of `dev`, `stag`, or `prod`.

## Deploy apps onto previously deployed cluster

```sh
./scripts/applications.sh $ENV all
```

## Dashboard

```sh
ENV=dev docker-compose up dash
```

### Get admin-user token for kubernetes-dashboard

```sh
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dash-user | awk '{print $1}')
```
