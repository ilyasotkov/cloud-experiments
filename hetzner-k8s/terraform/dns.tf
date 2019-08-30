variable "env" {
  type = string
}

variable "domain_zone" {
  type = string
}

variable "cluster_type" {
  type    = string
  default = "k8s"
}

locals {
  domain_suffix = var.env == "prod" ? var.cluster_type : ".${var.cluster_type}-${var.env}"
}

resource "cloudflare_record" "node_hostnames" {
  count = var.node_count

  domain = var.domain_zone
  name   = "${element(hcloud_server.nodes[*].name, count.index)}${local.domain_suffix}"
  value  = element(hcloud_server.nodes[*].ipv4_address, count.index)
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
