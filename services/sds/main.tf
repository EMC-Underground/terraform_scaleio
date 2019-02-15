variable "servers"{}
variable "datastore"{}
variable "ipv4_344" {}
variable "ipv4_siopg1"{}
variable "ipv4_siopg2"{}
variable "root_password"{}
variable "server_name"{}
variable "disk_attach_path"{}
variable "disk1_datastore"{}
variable "disk_attach_path1"{}
variable "disk2_datastore"{}
variable "disk_attach_path2"{}
variable "disk3_datastore"{}
variable "disk_attach_path3"{}
variable "disk4_datastore"{}

data "vsphere_datacenter" "dc" {
  name = "PacLabs"
}

data "vsphere_datastore" "datastore" {
  name = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "SIODev"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "SIODev/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "vlan344" {
  name          = "siodev_pg_344"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "sio_pg1" {
  name          = "siodev_sio_pg1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "sio_pg2" {
  name          = "siodev_sio_pg2"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "SIODev_CentOS7_Template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "SDSvm" {
  count            = "${var.servers}"
  name             = "${var.server_name}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = 2
  memory           = 1024
  guest_id         = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.vlan344.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  network_interface {
    network_id   = "${data.vsphere_network.sio_pg1.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  network_interface {
    network_id   = "${data.vsphere_network.sio_pg2.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  disk {
    label           = "disk1"
    attach          = true
    path            = "${var.disk_attach_path}"
    unit_number     = "2"
    datastore_id    = "${var.disk1_datastore}"
  }

  disk {
    label           = "disk2"
    attach          = true
    path            = "${var.disk_attach_path1}"
    unit_number     = "3"
    datastore_id    = "${var.disk2_datastore}"
  }

  disk {
    label           = "disk3"
    attach          = true
    path            = "${var.disk_attach_path2}"
    unit_number     = "4"
    datastore_id    = "${var.disk3_datastore}"
  }

  disk {
    label           = "disk4"
    attach          = true
    path            = "${var.disk_attach_path3}"
    unit_number     = "5"
    datastore_id    = "${var.disk4_datastore}"
  }


  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${var.server_name}"
        domain    = "pac.lab"
      }

     network_interface {
        ipv4_address = "${var.ipv4_344}"
        ipv4_netmask = 24
      }

      network_interface {
         ipv4_address = "${var.ipv4_siopg1}"
         ipv4_netmask = 24
      }

      network_interface {
         ipv4_address = "${var.ipv4_siopg2}"
         ipv4_netmask = 24
      }
      ipv4_gateway = "10.237.198.1"
      dns_server_list = ["10.237.198.254", "10.201.16.29"]
    }
  }

  provisioner "file" {
    source      = "C:/Users/soperb/Documents/Lab/PacLabs/SSH_Keys/authorized_keys"
    destination = "/root/.ssh/authorized_keys"

  connection {
    type     = "ssh"
    user     = "root"
    password = "${var.root_password}"
}
}
}
