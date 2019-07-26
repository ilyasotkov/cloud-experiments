terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "hcloud"
    }
  }
}

provider "hcloud" {
  version = "1.11.0"
}

provider "cloudflare" {
  version = "1.16.1"
}
