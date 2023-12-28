resource "proxmox_virtual_environment_file" "cloud_config" {
  count        = 3
  content_type = "snippets"
  datastore_id = "nas-nfs"
  node_name    = "server-0${count.index + 1}"

  source_raw {
    data = <<EOF
#cloud-config
hostname: k8s-node-0${count.index + 1}

users:
  - default
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    ssh-authorized-keys:
      - ${trimspace(var.ssh_public_key)}
    sudo: ALL=(ALL) NOPASSWD:ALL

write_files:
  - path: /etc/sudoers.d/cloud-init
    content: |
      Defaults !requiretty

package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - apt install -y linux-generic # we need the i915 driver for gpu passthrough, this isn't supported in the base cloud image

EOF
    # Prevent files overwriting eachother by giving them unique names with the count.index
    file_name = "ubuntu-terraform-cloud-config${count.index + 1}.yaml"
  }
}

resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  count        = 3
  content_type = "iso"
  datastore_id = "nas-nfs"
  node_name    = "server-0${count.index + 1}"

  source_file {
    path = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    file_name = "noble-server-cloudimg-amd64-${count.index + 1}.img"
  }
}