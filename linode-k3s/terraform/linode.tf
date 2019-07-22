variable "hostname_format" {
  default = "k3s-node-%d"
}

variable "node_count" {
  default = 3
}

variable "app_domain_names" {
  type    = list
  default = ["k3s"]
}

locals {
  linode_boot_config_label = "boot-config"
}

resource "linode_sshkey" "controller" {
  ssh_key = chomp(file("${path.cwd}/../ssh_pubkeys/id_rsa.pub"))
  label   = "controller"
}

resource "linode_instance" "nodes" {
  count = var.node_count

  label             = format(var.hostname_format, count.index + 1)
  type              = "g6-nanode-1"
  region            = "eu-west"
  private_ip        = false
  boot_config_label = local.linode_boot_config_label

  disk {
    label      = "swap"
    filesystem = "swap"
    size       = 512
  }

  disk {
    label           = "boot"
    filesystem      = "ext4"
    size            = 25088
    image           = "linode/ubuntu18.04"
    authorized_keys = ["${linode_sshkey.controller.ssh_key}"]
  }

  config {
    label       = local.linode_boot_config_label
    kernel      = "linode/grub2"
    root_device = "/dev/sda"

    devices {
      sda {
        disk_label = "boot"
      }
      sdb {
        disk_label = "swap"
      }
    }
  }
}

resource "linode_domain" "flexp_xyz" {
  type      = "master"
  domain    = "flexp.xyz"
  soa_email = "i@pxl.fi"
}

resource "linode_domain_record" "node_hostnames" {
  count = var.node_count

  domain_id   = linode_domain.flexp_xyz.id
  name        = format(var.hostname_format, count.index + 1)
  record_type = "A"
  ttl_sec     = 300
  target      = element(linode_instance.nodes[*].ip_address, count.index)
}

resource "linode_domain_record" "apps" {
  count = length(var.app_domain_names)

  domain_id   = linode_domain.flexp_xyz.id
  name        = element(var.app_domain_names, count.index)
  record_type = "A"
  ttl_sec     = 300
  target      = element(linode_instance.nodes[*].ip_address, 0)
}

output "node_public_ip_addresses" {
  value = linode_instance.nodes[*].ip_address
}

# output "node_private_ip_addresses" {
#   value = linode_instance.nodes[*].private_ip_address
# }

output "node_domain_names" {
  value = linode_domain_record.node_hostnames[*].name
}
