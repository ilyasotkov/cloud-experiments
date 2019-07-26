variable "hostname_format" {
  default = "k3s-node-%d"
}

variable "node_count" {
  default = 1
}
#
# resource "hcloud_server" "nodes" {
#   count = var.node_count
#
#   name        = format(var.hostname_format, count.index + 1)
#   image       = "ubuntu-18.04"
#   location    = "hel1"
#   server_type = "cx11"
#
#   user_data = <<USERDATA
# #cloud-config
# users:
# - name: admin
#   sudo: ALL=(ALL) NOPASSWD:ALL
#   ssh_authorized_keys:
#   - ${file("${path.cwd}/../ssh_pubkeys/id_rsa.pub")}
# USERDATA
# }
#
# resource "hcloud_server_network" "server_network" {
#   count = var.node_count
#
#   server_id = element(hcloud_server.nodes[*].id, count.index)
#   network_id = hcloud_network.vpc.id
#   ip = "10.0.1.${count.index + 1}"
# }
#
# output "node_ip_addresses" {
#   value = hcloud_server.nodes[*].ipv4_address
# }
