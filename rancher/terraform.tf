terraform {
  backend "remote" {
    organization = "ilyasotkov"

    workspaces {
      name = "rancher"
    }
  }
}
