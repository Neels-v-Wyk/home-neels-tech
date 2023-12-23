CLUSTER_NAME=$KUBERNETES_CLUSTER_NAME
cp -rfp inventory/sample /inventory/$CLUSTER_NAME
declare -a IPS=($KUBERNETES_IPS)
CONFIG_FILE=/inventory/$CLUSTER_NAME/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}