terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "linode-swarm"
    }
  }
}
