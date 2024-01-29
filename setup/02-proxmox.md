#### Hardware
```
model           : HP ProDesk 600 G3 Desktop Mini
# of units      : 3
CPU             : Intel Core i5-7500T
cores/threads   : 4/4
memory          : 24GB (1x8GB (stock) + 16GB Kingston Fury)
memory Max MT/s : 2400
memory Max Size : 32GB
OS              : Proxmox VE 8.1
M.2 NVME        : empty
2.5 SATA        : 512GB SSD
GPU             : Intel HD Graphics 630
```
#### Network configuration
```
hostname : server-0{1, 2, 3}.home
address  : 192.168.0.10{1, 2, 3} (static on router)
```
#### Foreword
I have three of these mini-pc's, so all these initial setup operations need to be repeated for each machine

I also make use of ZFS instead of Ceph because I don't need the added high availability of Ceph. This is just my home cluster and, while this will be a HA Proxmox cluster, it only needs to be fault tolerant *enough* against my tinkering

## Initial setup

### Prepare proxmox
These servers come with windows installed, which we won't be using.
1. Head on over to https://www.proxmox.com/en/downloads and get the latest version of Proxmox VE iso (I got 8.1-1, as that is the latest at the time of writing)
2. Burn that sucker onto a USB stick that you will struggle to find because no matter how many you buy you always can't seem to find one when you actually want to use it
3. Put the USB stick in the mini pc, power it on, and smash random F-keys until you manage to get into the BIOS to boot from the USB
	1. Double check that virtualization is enabled while you're in the BIOS
5. Start the proxmox installer
	1. Due to a bug that is (currently) unresolved, if the proxmox installer can gain a DHCP address and internet access, when it starts the installer it will try to determine the country of the machine but it will inexplicably hang. Open a different tty and run `killall traceroute`, the usual install process will continue from here and you can select the locatoin further in the process

### Proxmox initial configuration
1. Agree to the EULA
2. Change the initial hard drive configuration to only use a small amount of the SSD (I chose 50GB), the rest will be used for ZFS later
3. Set country, set admin details, set networking details (note that you need a FQDN for hostname, I chose server-01.home for my first server)
4. Continue with the setup and let proxmox install itself
5. On the next reboot after installation, it will wait for user interaction to boot. Set this to "Always continue to boot" when you hit this screen
6. You can now access the proxmox management interface on http://server.ip.ad.dr:8006

### Post setup steps
1. Open up a shell in the management interface and create a partition out of the remaining space on your device
3. Run the follwong proxmox post install script 
	1. `bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/post-pve-install.sh)"`
	2. This script provides options for managing Proxmox VE repositories, including disabling the Enterprise Repo, adding or correcting PVE sources, enabling the No-Subscription Repo, adding the test Repo, disabling the subscription nag, updating Proxmox VE, and rebooting the system
4. Create a cluster on your favorite node and join the cluster from the two other nodes
5. Set up ZFS with all the defaults, make sure the pool name is consistent accross all three nodes
6. Create a shared ZFS storage for all the nodes from the cluster management tab
7. Set up your ssh key by running `ssh-copy-id -i ~/.ssh/id_rsa root@192.168.0.101` (this should copy to all nodes if it's already clustered)
8. Install Ceph from Proxmox for distributed storage, set all nodes to monitors and managers, and use up what free space you have left in the volume group (~20GB for me) as a lv for ceph with `lvcreate -l 100%FREE -n pve/vz` followed by `ceph-volume lvm create --data pve/vz`
    1. You might also need to run `ceph auth get client.bootstrap-osd > /var/lib/ceph/bootstrap-osd/ceph.keyring` if you encounter auth errors
9. Add all servers as a metadata server, and create a cephfs called `k8s-local-cephfs`
8. Create an SDN # I COULD NOT GET THIS TO WORK. The other solution is probably a router inside a virtual network to assign DHCP addresses and route to the external network. Maybe I'll revisit this
 	1. Create an evpn controller with all nodes as peers
        2. Create an evpn zone with all nodes as exit nodes and 'local routing' enabled vnet and subnet in order to allow network communication between these nodes.
	3. Create the VNet and Subnets. Be sure to enable DHCP in the advanced settings for the subnet, as well as SNAT for internet access
	4. Add the following line in every node's `/etc/network/interfaces`: `source /etc/network/interfaces.d/*`
        5. Ensure that `frr-pythontools` is installed on all the nodes
        6. Press 'Apply' 	

And now we're ready to start setting up VMs for kubernetes :D
