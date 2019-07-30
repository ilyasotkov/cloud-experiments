variable "env" {
  type = string
}

variable "application_domain_names" {
  type    = list
  default = ["app"]
}

variable "domain_zone" {
  type = string
}

locals {
  domain_suffix = var.env == "prod" ? "k3s" : ".k3s-${var.env}"
}

resource "cloudflare_record" "node_hostnames" {
  count = var.node_count

  domain = var.domain_zone
  name   = "${element(hcloud_server.nodes[*].name, count.index)}${local.domain_suffix}"
  value  = element(hcloud_server.nodes[*].ipv4_address, count.index)
  type   = "A"
  ttl    = 1
}

resource "cloudflare_record" "application" {
  count = length(var.application_domain_names)

  domain = var.domain_zone
  name   = "${element(var.application_domain_names, count.index)}"
  value  = element(hcloud_server.nodes[*].ipv4_address, 0)
  type   = "A"
  ttl    = 1
}

output "node_domain_names" {
  value = cloudflare_record.node_hostnames[*].hostname
}
