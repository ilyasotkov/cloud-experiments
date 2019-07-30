# k3s cluster on Hetzner Cloud

## Prerequisites

- Docker Desktop on local workstation
- CloudFlare account (free plan)
- Hetzner Cloud account

## Start an interactive development session

```sh
docker-compose build && docker-compose run --rm controller bash
```

## Directory structure

- `scripts` automation scripts for invoking tasks
- `terraform` infrastructure code
- `ansible` code for provisioning or upgrading nodes in a cluster
- `resources` Kubernetes applications manifests (using Helmfile)
- `ssh_pubkeys` public keys for SSHing into nodes

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
ENV=dev docker-compose up dashboard
```
