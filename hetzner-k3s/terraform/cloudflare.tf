variable "app_domain_names" {
  type    = list
  default = ["a", "b", "c", "d"]
}

# resource "cloudflare_zone" "flexp_live" {
#   zone   = "flexp.live"
#   plan   = "free"
#   type   = "full"
#   paused = "false"
# }
#
# resource "cloudflare_record" "node_hostnames" {
#   count = var.node_count
#
#   domain = "flexp.live"
#   name   = format(var.hostname_format, count.index + 1)
#   value  = element(hcloud_server.nodes[*].ipv4_address, count.index)
#   type   = "A"
#   ttl    = 1
# }

# resource "cloudflare_record" "apps" {
#   count = length(var.app_domain_names)
#
#   domain = cloudflare_zone.flexp_live.zone
#   name   = "${element(var.app_domain_names, count.index)}.k3s"
#   value  = element(linode_instance.nodes[*].ip_address, 0)
#   type   = "A"
#   ttl    = 1
# }
# output "node_domain_names" {
#   value = cloudflare_record.node_hostnames[*].hostname
# }
