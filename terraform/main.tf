
provider "proxmox" {
  endpoint = "https://${var.proxmox_ve_node_2_ip}:8006/api2/json"

  # The Proxmox VE API doesn't allow some operations when using token authentication
  # so we'll have to use username/password authentication
  username = var.proxmox_ve_username
  password = var.proxmox_ve_password
  insecure = true

  ssh {
    agent = true

    # We sadly can't template these out so we'll have to live with some repitition
    node {
      name    = var.proxmox_ve_node_1_name
      address = var.proxmox_ve_node_1_ip
    }
    node {
      name    = var.proxmox_ve_node_2_name
      address = var.proxmox_ve_node_2_ip
    }
    node {
      name    = var.proxmox_ve_node_3_name
      address = var.proxmox_ve_node_3_ip
    }
  }
}
