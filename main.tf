provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}



resource "esxi_guest" "web_server" {
  

  guest_name = var.web_server_name
  disk_store = var.disk_store

  boot_disk_size = "15"
  memsize  = var.vm_memory
  numvcpus = var.vm_cpu

  ovf_source = var.ubuntu_ova_url

  network_interfaces {
    virtual_network = var.virtual_network
  }

  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata" = base64gzip(templatefile("${path.module}/userdata.tftpl", {
      user                = var.user
      ssh_authorized_keys = var.ssh_authorized_keys
      }))

    
  }
}

resource "esxi_guest" "database_server" {

  guest_name = var.database_server_name
  disk_store = var.disk_store
  
  boot_disk_size = "15"
  memsize  = var.vm_memory
  numvcpus = var.vm_cpu

  ovf_source = var.ubuntu_ova_url

  network_interfaces {
    virtual_network = var.virtual_network
  }

  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata" = base64gzip(templatefile("${path.module}/userdata.tftpl", {
      user                = var.user
      ssh_authorized_keys = var.ssh_authorized_keys
      }))

    
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = <<EOT  
[web_servers]
${esxi_guest.web_server.guest_name}: ${esxi_guest.web_server.ip_address}

[database_servers]
${esxi_guest.database_server.guest_name}: ${esxi_guest.database_server.ip_address} 

[web_servers:vars]


[all:vars]
ansible_user=${var.user}
ansible_ssh_private_key_file=~/.ssh/id_ed25519
esxi_host=${var.esxi_hostname}

EOT
}

resource "local_file" "outputs" {
  filename = "${path.module}/outputs.txt"

  content = <<EOT 
Web_servers:
${join("\n", esxi_guest.web_servers[*].ip_address)}

Database_servers:
${join("\n", esxi_guest.database_server[*].ip_address)} 

EOT
}