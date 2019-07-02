provider "linode" {}

resource "linode_sshkey" "controller" {
  ssh_key = "${chomp(file("${path.cwd}/ssh/id_rsa.pub"))}"
  label   = "controller"
}

resource "linode_instance" "swarm_node" {
  label             = "swarm_node"
  type              = "g6-nanode-1"
  region            = "eu-central"
  private_ip        = false
  boot_config_label = "boot"

  group = "swarm"
  tags  = ["swarm_node"]

  disk {
    label           = "boot"
    size            = 25000
    image           = "linode/ubuntu18.04"
    authorized_keys = ["${linode_sshkey.controller.ssh_key}"]
  }

  config {
    label       = "boot"
    kernel      = "linode/4.14.120-x86_64-linode125"
    root_device = "/dev/sda"

    devices {
      sda = {
        disk_label = "boot"
      }
    }
  }
}

resource "linode_domain" "flexp_xyz" {
  type      = "master"
  domain    = "flexp.xyz"
  soa_email = "soa@flexp.xyz"
}

resource "linode_domain_record" "arch_flexp_xyz" {
  domain_id   = "${linode_domain.flexp_xyz.id}"
  name        = "arch"
  record_type = "A"
  target      = "arch.flexp.xyz"
  ttl_sec     = 300
  expire_sec  = 300
  retry_sec   = 300
  refresh_sec = 300
}

output "swarm_node_ip_address" {
  value = "${linode_instance.swarm_node.ip_address}"
}
