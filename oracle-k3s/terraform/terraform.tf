terraform {
  backend "remote" {
    organization = "flexp"

    workspaces {
      prefix = "oci-"
    }
  }
}
