provider "linode" {}

resource "linode_sshkey" "controller" {
  ssh_key = "${chomp(file("${path.cwd}/ssh/id_rsa.pub"))}"
  label   = "controller"
}

resource "linode_instance" "swarm" {
  label  = "swarm"
  type   = "g6-nanode-1"
  region = "eu-central"

  group             = "swarm"
  tags              = ["swarm"]
  private_ip        = false
  boot_config_label = "boot"

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

output "ip_address" {
  value = "${linode_instance.swarm.ip_address}"
}
