# Passing through the intel iGPU

Since this server cluster is likely going to be serving/transcoding video, it would be really great if we could use the handy features provided by the integrated GPU from the intel CPU

### Proxmox changes
For each node, we need to ensure that we have IOMMU enabled

Add this line to `/etc/default/grub`:
```GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"```

Next, add the required kernel modules to `/etc/modules`:
```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

Run `update grub` to solidify your changes and reboot.

### Adding the GPU to VMs

Run `lspci` to identify the GPU:
```
root@server-01:~# lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v6/7th Gen Core Processor Host Bridge/DRAM Registers (rev 05)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 630 (rev 04)  <-----
00:14.0 USB controller: Intel Corporation 200 Series/Z370 Chipset Family USB 3.0 xHCI Controller
00:14.2 Signal processing controller: Intel Corporation 200 Series PCH Thermal Subsystem
```

Now that you've identified the GPU, you can add it as part of you terraform when creating the nodes