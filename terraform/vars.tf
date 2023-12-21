variable "proxmox_ve_node_1_ip" {
    type        = string
    description = "IP Address of the first Proxmox VE node"
}

variable "proxmox_ve_node_2_ip" {
    type        = string
    description = "IP Address of the second Proxmox VE node"
}

variable "proxmox_ve_node_3_ip" {
    type        = string
    description = "IP Address of the third Proxmox VE node"
}

variable "proxmox_ve_username" {
    type        = string
    description = "Username for the Proxmox VE API"
}

variable "proxmox_ve_password" {
    type        = string
    description = "Password for the Proxmox VE API"
}

variable "proxmox_ve_node_1_name" {
    type        = string
    description = "Name of the first Proxmox VE node"
}

variable "proxmox_ve_node_2_name" {
    type        = string
    description = "Name of the second Proxmox VE node"
}

variable "proxmox_ve_node_3_name" {
    type        = string
    description = "Name of the third Proxmox VE node"
}

variable ssh_public_key {
    type        = string
    description = "SSH public key to be used for the VMs"
}