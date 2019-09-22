variable "compartment_id" {}

resource "oci_core_vcn" "vcn1" {
  display_name   = "vcn1"
  dns_label      = "vcn1"
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
}

resource "oci_core_subnet" "subnet1" {
  display_name   = "subnet1"
  dns_label      = "subnet1"
  cidr_block     = "10.0.1.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn1.id

  route_table_id = oci_core_route_table.route_table.id
}

resource "oci_core_internet_gateway" "igw" {
  enabled        = "true"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "igw"
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "route_table"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}
