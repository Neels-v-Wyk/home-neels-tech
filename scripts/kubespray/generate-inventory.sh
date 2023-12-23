#!/bin/bash
set -exo

# adapted from https://github.com/PragmaticEngineering/kubespray-docker

KUBERNETES_CLUSTER_NAME=$1
declare -a IPS=($2 $3 $4)

cp -rfp /inventory/ ./inventory/$KUBERNETES_CLUSTER_NAME
CONFIG_FILE=./inventory/$KUBERNETES_CLUSTER_NAME/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
cp -rfp ./inventory/$KUBERNETES_CLUSTER_NAME/hosts.yaml /inventory/$KUBERNETES_CLUSTER_NAME/hosts.yaml