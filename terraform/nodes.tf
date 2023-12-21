resource "proxmox_virtual_environment_vm" "kube-node-1" {
  name        = "kube-node-{count.index + 1}"
  description = "Kubernetes Node Managed by Terraform"
  tags        = ["terraform", "ubuntu", "kubernetes"]

  node_name = "server-0{count.index + 1}"
  vm_id     = "100{count.index + 1}"

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    sockets = 1
    type = "host"
  }

  # Passthrough Zigbee dongle for home assistant
  usb {
    host = "10c4:ea60"
    usb3 = true
  }

  startup {
    order      = "1{count.index + 1}"
    up_delay   = "30"
    down_delay = "60"
  }

  disk {
    datastore_id = "server-zfs-storage"
    interface    = "scsi0"
    size        = "50G"
  }

  clone {
    datastore_id = "server-zfs-storage"
    node_name    = "server-01"
    vm_id        = "9000"
  }

  initialization {
    ip_config {
      dns = "1.1.1.1, 1.0.0.1"
      ipv4 {
        address = "192.168.0.5{count.index + 1}/24"
        gateway = "192.168.0.1"
      }
    }

    user_account {
      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = random_password.ubuntu_vm_password.result
      username = "ubuntu"
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    datastore_id = "server-zfs-storage"
  }

  serial_device {}
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}
