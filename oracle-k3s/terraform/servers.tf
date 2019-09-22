variable "node_count" {
  type    = number
  default = 1
}

variable "availability_domain" {
  # TODO: replace with datasource
  default = "OmrV:EU-FRANKFURT-1-AD-1"
}

variable "instance_image_ocid" {
  # TODO: replace with datasource
  default = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa2c2cncycdx7h6vvnmcwkbvduxxbq3hog5vq3pt56wisfzvo5v4fq"
}

resource "oci_core_network_security_group" "sg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn1.id
}

resource "oci_core_network_security_group_security_rule" "egress" {
  network_security_group_id = oci_core_network_security_group.sg.id

  direction        = "EGRESS"
  protocol         = "all"
  destination_type = "CIDR_BLOCK"
  destination      = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "ingress_private" {
  network_security_group_id = oci_core_network_security_group.sg.id

  direction   = "INGRESS"
  protocol    = "all"
  source_type = "CIDR_BLOCK"
  source      = "10.0.0.0/16"
}

resource "oci_core_network_security_group_security_rule" "ingress_public" {
  network_security_group_id = oci_core_network_security_group.sg.id

  direction   = "INGRESS"
  protocol    = "6"
  source_type = "CIDR_BLOCK"
  source      = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
  }
}

resource "oci_core_instance" "nodes" {
  count = var.node_count

  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id

  display_name = count.index == 0 ? "master" : format("worker-%d", count.index)
  shape        = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet1.id
    assign_public_ip = true
    hostname_label   = count.index == 0 ? "master" : format("worker-%d", count.index)
    display_name     = "${count.index == 0 ? "master" : format("worker-%d", count.index)}-vnic"
    nsg_ids          = [oci_core_network_security_group.sg.id]
  }

  source_details {
    source_type             = "image"
    source_id               = var.instance_image_ocid
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = file("${path.cwd}/../ssh_pubkeys/id_rsa_${var.env}.pub")
    user_data = base64encode(
      templatefile("${path.cwd}/cloud-config.yaml", {
        ssh_pubkey = chomp(file("${path.cwd}/../ssh_pubkeys/id_rsa_${var.env}.pub"))
      })
    )
  }
}

# resource "oci_core_instance_console_connection" "console_connection" {
#   instance_id = oci_core_instance.nodes[0].id
#   public_key  = file("${path.cwd}/../ssh_pubkeys/id_rsa_${var.env}.pub")
# }

output "node_ip_addresses" {
  value = oci_core_instance.nodes[*].public_ip
}
