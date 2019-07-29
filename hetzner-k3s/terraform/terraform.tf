terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      prefix = "hcloud-"
    }
  }
}

provider "hcloud" {
  version = "1.11.0"
}

provider "cloudflare" {
  version = "1.16.1"
}
