#!/bin/bash

# get secrets first
source .env

# Iterate over directories in ./kubernetes
for dir in ./kubernetes/base/*; do
    if [ -d "$dir" ]; then
        # Install using kustomize
        KUBECONFIG=ansible/inventory/$KUBERNETES_CLUSTER_NAME/artifacts/admin.conf kubectl kustomize --enable-helm $dir | envsubst | kubectl apply -f -
    fi
done