# Variable declarations
variable "vsphere_admin_user" {
  description = "vsphere Administrator username"
  type        = string
  sensitive   = true
}

variable "vsphere_admin_password" {
  description = "vshpere Administrator password"
  type        = string
  sensitive   = true
}

variable "vsphere_server_ip" {
  description = "vshpere Server IP Address"
  type        = number
  #default = "192.168.20.x"
}

variable "datacenter_name" {
  description = "The name of the Datacenter where vCenter is located."
  type        = string
  default     = "California"
}

variable "datastore_name" {
  description = "Datastore name where the VM is to be deployed into."
  type        = string
  default     = "WorkloadDatastore-Internal"
}
variable "cluster_name" {
  description = "Cluster name where the VM is to be deployed into."
  type        = string
  default     = "Cluster-01"
}

variable "network_name" {
  description = "Network where the VM should belong to."
  type        = string
  default     = "Server VLAN"
}

variable "template_name" {
  description = "VM Template to use."
  type        = string
  default     = "RedHat_CentOS"
}

variable "vm_name" {
  description = "Virtual Machine Name."
  type        = string
  default     = "terraform-test01"
}