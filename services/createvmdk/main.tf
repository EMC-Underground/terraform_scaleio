variable "datastore"{}
variable "disk_attach_path_name"{}

data "vsphere_datacenter" "dc" {
  name = "PacLabs"
}

data "vsphere_datastore" "datastore" {
  name = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_disk" "myDisk" {
  size         = 500
  vmdk_path    = "${var.disk_attach_path_name}"
  datacenter   = "PacLabs"
  datastore    = "${var.datastore}"
  type         = "thin"
}

output "disk1_datastore_id" {
  value = "${data.vsphere_datastore.datastore.id}"
}
