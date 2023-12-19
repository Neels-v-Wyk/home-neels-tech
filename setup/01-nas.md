#### Hardware
```
model        : TS-439 PRO II
hostname     : nas-01
address      : 192.168.0.110 (static on router)
network mode : DHCP
```
#### Storage
```
model              : Seagate Exos 7E8 SATA (Standard model)
# of units         : 4
size               : 6TB
RAID configuration : 5
fault tolerance    : 1 drive
```

## Initial Setup
Setting up the NAS:

1. Power on device with no drives plugged in
2. Log in via network at either http://ip-address:8080 or https://ip-address
3. Confirm that the NAS can enter it's first time configuration mode
4. Plug in all the drives
5. Run the initialization process and choose RAID type (I chose 5 for 1 drive fault tolerance between 4 drives)
6. Change admin password and add users
7. Set up NFS for shared storage
	1. Check the "enable NFS" under the "Network Services" tab
	2. Disable write caching in the "Hardware" tab
	3. Create an NFS shared folder with all the advanced settings turned off
	4. Enable "Advanced Permissions Editor"
	5. Edit the shared folder's permissions and select the "NFS host access" permission type and allow access to the IP range of the proxmox servers (if they've been set up)
8. Consider moving the NAS out of the living room because it turns out hard drives make a bunch of sound :')
