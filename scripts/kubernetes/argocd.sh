#!/bin/bash

# get secrets first
source .env

# Iterate over directories in ./kubernetes
for dir in ./kubernetes/argocd/*; do
    if [ -d "$dir" ]; then
        # Applying manifest
        KUBECONFIG=ansible/inventory/$KUBERNETES_CLUSTER_NAME/artifacts/admin.conf cat $dir/*argocd.yaml | envsubst | kubectl apply -f -
    fi
done