# Creating a VM template

## DEPRECATED
This step can be skipped.

This way is the more manual way of doing things. It was originally done this because the terraform provider was limited in that it could not do this on it's own. Using a new terraform provider that's something we can do, so just change the `template.tf` file in the terraform directory

### Setting things up

In order to make this server deployable from terraform, we need a template that we will be specifying. I'll be using ubuntu for this.

You can find the latest cloud base images for ubuntu at https://cloud-images.ubuntu.com/, so for met that's https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img

These commands can really just be all ran on one of the nodes in order to create the base template as we want it:
```bash
cd /tmp/
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
apt update -y && apt install libguestfs-tools -y
virt-customize -a noble-server-cloudimg-amd64.img --install qemu-guest-agent
qm create 9000 --name "ubuntu-2404-cloudinit-template" --memory 4096 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 noble-server-cloudimg-amd64.img server-zfs-storage
qm set 9000 --scsihw virtio-scsi-pci --scsi0 server-zfs-storage:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 server-zfs-storage:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm set 9000 --sshkey ~/.ssh/id_rsa.pub
qm template 9000
rm noble-server-cloudimg-amd64.img
```
You'll still need to expand the boot disk after this if you run this image directly
