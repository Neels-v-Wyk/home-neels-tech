# Looks at which of the k8s nodes have a sonoff dongle connected (via usb passthrough) and labels that node
# This way the home assistant pod can only run on that node

#!/bin/bash

# SSH into the remote machine and run lsusb
servers=(
	192.168.0.51
	192.168.0.52
	192.168.0.53
)

# Loop through the servers and copy the SSH key
for server in "${servers[@]}"
do
    kubectl label node $server zigbee=false
    ssh ubuntu@$server "lsusb" | grep -q "UART"
    if [ $? -eq 0 ]; then
        GOOD_NODE=`kubectl get nodes -o wide | grep $server | awk '$6{print $1}'` && kubectl label node $GOOD_NODE zigbee=true
    fi
done