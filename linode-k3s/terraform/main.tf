terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "linode-k3s"
    }
  }
}

provider "linode" {
  version = "1.8.0"
}
