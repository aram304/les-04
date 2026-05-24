# ESXI

variable "esxi_hostname" {
  type = string
}

variable "esxi_hostport" {
  type    = string
  default = "22"
}

variable "esxi_hostssl" {
  type    = string
  default = "443"
}

variable "esxi_username" {
  type    = string
  default = "root"
}

variable "esxi_password" {
  type      = string
  sensitive = true
}

variable "vm_memory" {
    type    = number
    default = 2048
}

variable "vm_cpu" {
    type    = number
    default = 1
}

variable "disk_store" {
  type    = string
  default = "datastore1"
}


variable "vmname" {
    type    = string
    default = "les-03"
}

variable "ubuntu_ova_url" {
  type    = string
  default = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
}

variable "virtual_network" {
  type    = string
  default = "VM Network"
}

variable "ssh_authorized_keys" {
  type    = string
}

variable "user" {
  type    = string
}

variable "web_server_name" {
  type    = string
  default = "webserver"
}

variable "database_server_name" {
  type    = string
  default = "database"
}