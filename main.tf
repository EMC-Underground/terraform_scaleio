provider "vsphere" {
  user                 = "${var.vsphere_user}"
  password             = "${var.vsphere_password}"
  vsphere_server       = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

# Stores the terraform state file in S3 bucket.
terraform {
  backend "s3" {
    bucket = "brad.bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

module "GATEWAYvm" {
  source        = "services/gateway"
  servers       = "1"
  datastore     = "PacLabs007_Boot"
  ipv4_344      = "10.237.198.140"
  ipv4_siopg1   = "192.168.10.140"
  ipv4_siopg2   = "192.168.11.140"
  root_password = "${var.root_password}"
}

module "SDSvm1_Disk1" {
  source                = "services/createvmdk"
  datastore             = "PacLabs007-SIO-1"
  disk_attach_path_name = "SDSvm1_Disk1.vmdk"
}

module "SDSvm1_Disk2" {
  source                = "services/createvmdk"
  datastore             = "PacLabs007-SIO-2"
  disk_attach_path_name = "SDSvm1_Disk2.vmdk"
}

module "SDSvm1_Disk3" {
  source                = "services/createvmdk"
  datastore             = "PacLabs007-SIO-3"
  disk_attach_path_name = "SDSvm1_Disk3.vmdk"
}

module "SDSvm1_Disk4" {
  source                = "services/createvmdk"
  datastore             = "PacLabs007-SIO-4"
  disk_attach_path_name = "SDSvm1_Disk4.vmdk"
}

module "SDSvm2_Disk1" {
  source                = "services/createvmdk"
  datastore             = "PacLabs008-SIO-1"
  disk_attach_path_name = "SDSvm2_Disk1.vmdk"
}

module "SDSvm2_Disk2" {
  source                = "services/createvmdk"
  datastore             = "PacLabs008-SIO-3"
  disk_attach_path_name = "SDSvm2_Disk2.vmdk"
}

module "SDSvm2_Disk3" {
  source                = "services/createvmdk"
  datastore             = "PacLabs008-SIO-3"
  disk_attach_path_name = "SDSvm2_Disk3.vmdk"
}

module "SDSvm2_Disk4" {
  source                = "services/createvmdk"
  datastore             = "PacLabs008-SIO-4"
  disk_attach_path_name = "SDSvm2_Disk4.vmdk"
}

module "SDSvm3_Disk1" {
  source                = "services/createvmdk"
  datastore             = "PacLabs009-SIO-1"
  disk_attach_path_name = "SDSvm3_Disk1.vmdk"
}

module "SDSvm3_Disk2" {
  source                = "services/createvmdk"
  datastore             = "PacLabs009-SIO-2"
  disk_attach_path_name = "SDSvm3_Disk2.vmdk"
}

module "SDSvm3_Disk3" {
  source                = "services/createvmdk"
  datastore             = "PacLabs009-SIO-3"
  disk_attach_path_name = "SDSvm3_Disk3.vmdk"
}

module "SDSvm3_Disk4" {
  source                = "services/createvmdk"
  datastore             = "PacLabs009-SIO-4"
  disk_attach_path_name = "SDSvm3_Disk4.vmdk"
}

module "SDSvm1" {
  source            = "services/sds"
  servers           = "1"
  datastore         = "PacLabs007_Boot"
  ipv4_344          = "10.237.198.141"
  ipv4_siopg1       = "192.168.10.141"
  ipv4_siopg2       = "192.168.11.141"
  root_password     = "${var.root_password}"
  server_name       = "terraform-SIOSVM1"
  disk_attach_path  = "SDSvm1_Disk1.vmdk"
  disk1_datastore   = "${module.SDSvm1_Disk1.disk1_datastore_id}"
  disk_attach_path1 = "SDSvm1_Disk2.vmdk"
  disk2_datastore   = "${module.SDSvm1_Disk2.disk1_datastore_id}"
  disk_attach_path2 = "SDSvm1_Disk3.vmdk"
  disk3_datastore   = "${module.SDSvm1_Disk3.disk1_datastore_id}"
  disk_attach_path3 = "SDSvm1_Disk4.vmdk"
  disk4_datastore   = "${module.SDSvm1_Disk4.disk1_datastore_id}"
}

module "SDSvm2" {
  source            = "services/sds"
  servers           = "1"
  datastore         = "PacLabs008_Boot"
  ipv4_344          = "10.237.198.142"
  ipv4_siopg1       = "192.168.10.142"
  ipv4_siopg2       = "192.168.11.142"
  root_password     = "${var.root_password}"
  server_name       = "terraform-SIOSVM2"
  disk_attach_path  = "SDSvm2_Disk1.vmdk"
  disk1_datastore   = "${module.SDSvm2_Disk1.disk1_datastore_id}"
  disk_attach_path1 = "SDSvm2_Disk2.vmdk"
  disk2_datastore   = "${module.SDSvm2_Disk2.disk1_datastore_id}"
  disk_attach_path2 = "SDSvm2_Disk3.vmdk"
  disk3_datastore   = "${module.SDSvm2_Disk3.disk1_datastore_id}"
  disk_attach_path3 = "SDSvm2_Disk4.vmdk"
  disk4_datastore   = "${module.SDSvm2_Disk4.disk1_datastore_id}"
}

module "SDSvm3" {
  source            = "services/sds"
  servers           = "1"
  datastore         = "PacLabs009_Boot"
  ipv4_344          = "10.237.198.143"
  ipv4_siopg1       = "192.168.10.143"
  ipv4_siopg2       = "192.168.11.143"
  root_password     = "${var.root_password}"
  server_name       = "terraform-SIOSVM3"
  disk_attach_path  = "SDSvm3_Disk1.vmdk"
  disk1_datastore   = "${module.SDSvm3_Disk1.disk1_datastore_id}"
  disk_attach_path1 = "SDSvm3_Disk2.vmdk"
  disk2_datastore   = "${module.SDSvm3_Disk2.disk1_datastore_id}"
  disk_attach_path2 = "SDSvm3_Disk3.vmdk"
  disk3_datastore   = "${module.SDSvm3_Disk3.disk1_datastore_id}"
  disk_attach_path3 = "SDSvm3_Disk4.vmdk"
  disk4_datastore   = "${module.SDSvm3_Disk4.disk1_datastore_id}"
}
