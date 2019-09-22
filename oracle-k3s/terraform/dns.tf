variable "env" {
  type = string
}

variable "domain_zone" {
  type = string
}

variable "cluster_type" {
  type    = string
  default = "oci-k3s"
}

locals {
  domain_suffix = var.env == "prod" ? var.cluster_type : ".${var.cluster_type}-${var.env}"
}

resource "cloudflare_record" "node_hostnames" {
  count = var.node_count

  domain = var.domain_zone
  name   = "${element(oci_core_instance.nodes[*].display_name, count.index)}${local.domain_suffix}"
  value  = element(oci_core_instance.nodes[*].public_ip, count.index)
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
