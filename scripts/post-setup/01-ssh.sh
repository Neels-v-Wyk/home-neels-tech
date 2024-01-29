servers=(
	192.168.0.51
	192.168.0.52
	192.168.0.53
)

# Loop through the servers and copy the SSH key
for server in "${servers[@]}"
do
    echo "Copying SSH key to $server"
    scp ~/.ssh/id_rsa* ubuntu@$server:.ssh/
done

