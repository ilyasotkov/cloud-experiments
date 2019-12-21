variable "node_count" {
  type    = number
  default = 3
}

resource "hcloud_server" "nodes" {
  count = var.node_count

  name        = count.index == 0 ? "master" : format("worker-%d", count.index)
  image       = "ubuntu-18.04"
  location    = "hel1"
  server_type = "cx21"
  ssh_keys    = [hcloud_ssh_key.default.id]

  user_data = <<USERDATA
#cloud-config
fqdn: ${format(count.index == 0 ? "master" : format("worker-%d", count.index))}.${var.domain_zone}
users:
- name: admin
  shell: /bin/bash
  sudo: ALL=(ALL) NOPASSWD:ALL
  ssh_authorized_keys:
  - ${file("${path.cwd}/../ssh_pubkeys/id_rsa_${var.env}.pub")}
USERDATA
}

resource "hcloud_ssh_key" "default" {
  name       = "default"
  public_key = file("${path.cwd}/../ssh_pubkeys/id_rsa_${var.env}.pub")
}

resource "hcloud_server_network" "server_network" {
  count = var.node_count

  server_id  = element(hcloud_server.nodes[*].id, count.index)
  network_id = hcloud_network.vpc.id
  ip         = "10.0.1.${count.index + 1}"
}

output "node_ip_addresses" {
  value = hcloud_server.nodes[*].ipv4_address
}
