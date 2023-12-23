resource "proxmox_virtual_environment_vm" "k8s-node" {

  count       = 3
  name        = "k8s-node-${count.index + 1}"
  description = "Kubernetes Node Managed by Terraform"
  tags        = ["terraform", "ubuntu", "kubernetes"]

  node_name = "server-0${count.index + 1}"
  vm_id     = 801 + count.index

  agent {
    enabled = true
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  # USB Passthrough Zigbee dongle for home assistant. 
  usb {
   host = "10c4:ea60"
   usb3 = true
  }

  # GPU Passthrough for jellyfin. 
  hostpci {
   device = "hostpci0"
  id     = "0000:00:02"
  }

  startup {
    order      = count.index + 10
    up_delay   = "30"
    down_delay = "60"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = "50"
    file_id      = proxmox_virtual_environment_file.ubuntu_cloud_image[count.index].id
  }

  boot_order = ["scsi0", "ide2"]

  initialization {

    ip_config {
      ipv4 {
        address = "192.168.0.5${count.index + 1}/24"
        gateway = "192.168.0.1"
      }
    }

    user_account {
      keys     = [var.ssh_public_key]
      password = random_password.ubuntu_vm_password.result
      username = "ubuntu"
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config[count.index].id
  }


  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    datastore_id = "local-lvm"
  }

  serial_device {}
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}
