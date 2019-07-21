terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "linode-swarm"
    }
  }
}

provider "linode" {
  version = "1.7.0"
}
