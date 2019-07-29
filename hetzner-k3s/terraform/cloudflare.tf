variable "app_domain_names" {
  type    = list
  default = ["app"]
}

variable "domain_zone" {
  default = "flexp.live"
}

# resource "cloudflare_zone" "flexp_live" {
#   zone   = "flexp.live"
#   plan   = "free"
#   type   = "full"
#   paused = "false"
# }

resource "cloudflare_record" "node_hostnames" {
  count = var.node_count

  domain = var.domain_zone
  name   = element(hcloud_server.nodes[*].name, count.index)
  value  = element(hcloud_server.nodes[*].ipv4_address, count.index)
  type   = "A"
  ttl    = 1
}

resource "cloudflare_record" "apps" {
  count = length(var.app_domain_names)

  domain = var.domain_zone
  name   = "${element(var.app_domain_names, count.index)}.k3s"
  value  = element(hcloud_server.nodes[*].ipv4_address, 0)
  type   = "A"
  ttl    = 1
}

output "node_domain_names" {
  value = cloudflare_record.node_hostnames[*].hostname
}
