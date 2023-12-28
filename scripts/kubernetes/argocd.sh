#!/bin/bash

# get secrets first
source .env

# Iterate over directories in ./kubernetes
for dir in ./kubernetes/argocd/*; do
    if [ -d "$dir" ]; then
        # Applying manifest
        KUBECONFIG=ansible/inventory/$KUBERNETES_CLUSTER_NAME/artifacts/admin.conf kubectl apply -f $dir/*argocd.yaml
    fi
done