output "node_ip_addresses" {
  description = "IP address of the kubernetes node, used at a later stage for ansible"
  value       = proxmox_virtual_environment_vm.k8s-node[*].ipv4_addresses[1]
}