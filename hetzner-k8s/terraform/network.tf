resource "hcloud_network" "vpc" {
  name     = "vpc"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "cluster" {
  network_id   = hcloud_network.vpc.id
  type         = "server"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}
