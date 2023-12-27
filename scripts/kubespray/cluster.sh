# from https://github.com/PragmaticEngineering/kubespray-docker

clustername=$1

cp -r /inventory/ ./inventory/$clustername

INVENTORY_PATH="./inventory/$clustername"

if [ -z "$clustername" ]
then
    echo "Please provide cluster name"
    exit 1
fi


if [ ! -d "$INVENTORY_PATH" ]
then
    echo "Inventory $clustername does not exist"
    exit 1
fi

if [ ! -f "$INVENTORY_PATH/hosts.yaml" ]
then
    echo "Inventory $clustername does not have hosts.yaml"
    exit 1
fi

if [ ! -f "$INVENTORY_PATH/cluster-variables.yaml" ]
then
    echo "Inventory $clustername does not have cluster-variables.yaml"
    exit 1
fi

ansible-playbook -i $INVENTORY_PATH/hosts.yaml \
-e @$INVENTORY_PATH/cluster-variables.yaml \
--become --become-user=root -u ubuntu cluster.yml

cp -rfp $INVENTORY_PATH/ /inventory/