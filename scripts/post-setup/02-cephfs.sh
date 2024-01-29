servers=(
	192.168.0.51
	192.168.0.52
	192.168.0.53
)

for server in "${servers[@]}"
do
    ssh ubuntu@$server 'sudo mkdir -p -m 755 /etc/ceph'
    ssh ubuntu@$server 'ssh -o StrictHostKeyChecking=no root@192.168.0.101 "sudo ceph config generate-minimal-conf" | sudo tee /etc/ceph/ceph.conf'
    ssh ubuntu@$server 'sudo chmod 644 /etc/ceph/ceph.conf'
    ssh ubuntu@$server 'ssh -o StrictHostKeyChecking=no root@192.168.0.101 "cat /etc/ceph/ceph.client.admin.keyring" | sudo tee /etc/ceph/ceph.client.admin.keyring'
    ssh ubuntu@$server 'sudo chmod 600 /etc/ceph/ceph.client.admin.keyring'
    ssh ubuntu@$server 'sudo apt install -y ceph-common'
    ssh ubuntu@$server 'echo "192.168.0.101:6789,192.168.0.102:6789,192.168.0.103:6789:/     /mnt/kubernetes    ceph    name=admin,noatime,_netdev    0       2" | sudo tee -a /etc/fstab'
    ssh ubuntu@$server 'sudo mkdir /mnt/kubernetes; sudo mount -t ceph admin@.k8s-local-cephfs=/ /mnt/kubernetes -o mon_addr=192.168.0.101'
done

