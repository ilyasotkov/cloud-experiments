variable "env" {
  type = string
}

variable "domain_zone" {
  type = string
}

variable "cluster_type_suffix" {
  type    = string
  default = "swarm"
}

variable "create_domain_names" {
  type    = set(string)
  default = []
}

locals {
  domain_suffix = var.env == "prod" ? var.cluster_type_suffix : ".${var.cluster_type_suffix}-${var.env}"
}

resource "cloudflare_record" "node_hostnames" {
  count = var.node_count

  domain = var.domain_zone
  name   = "${element(hcloud_server.nodes[*].name, count.index)}${local.domain_suffix}"
  value  = element(hcloud_server.nodes[*].ipv4_address, count.index)
  type   = "A"
  ttl    = 1
}

resource "cloudflare_record" "domain_names" {
  for_each = var.create_domain_names

  domain = var.domain_zone
  name   = each.value
  value  = hcloud_server.nodes[0].ipv4_address
  type   = "A"
  ttl    = 1
}

output "domain_zone" {
  value = "${var.domain_zone}"
}

output "node_domain_names" {
  value = cloudflare_record.node_hostnames[*].hostname
}

output "env" {
  value = var.env
}
