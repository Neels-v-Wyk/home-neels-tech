SHELL := /bin/bash
include .env

.PHONY: help clean vms vms-destroy demolish kubernetes services home

help: # Show the function of different make targets
	@echo "Available targets:"
	@echo "  help        : Show the function of different make targets"
	@echo "  vms         : Create VMs in proxmox with terraform"
	@echo "  vms-destroy : Destroy VMs in proxmox with terraform"
	@echo "  kubernetes  : Uses kubespray to install kubernetes to nodes"
	@echo "  services    : Install services to kubernetes cluster using kustomize"
	@echo "  clean       : Clean up the local environment"
	@echo "  demolish    : Destroy VMs in proxmox and clean up the local environment"
	@echo "  home        : Create VMs, install k8s and services, and go make a cup of tea :D"

clean: # Clean up the local environment
	@echo "Cleaning up the local environment"
	rm -rf ansible/home-cluster
	rm -rf tempdir/

vms: # Create VMs in proxmox
	@echo "Creating VMs in proxmox"
	source .env && \
	cd terraform && \
	terraform init -upgrade && \
	terraform apply -auto-approve

vms-destroy: # Destroy VMs in proxmox
	@echo "Destroying VMs in proxmox"
	source .env && \
	cd terraform && \
	terraform init -upgrade && \
	terraform destroy -auto-approve

demolish: vms-destroy clean # Destroy VMs in proxmox and clean up the local environment
	@echo "Destroying VMs in proxmox and cleaning up the local environment"

kubernetes-pre-setup: # Install kubernetes to VMs
	@echo "Installing kubernetes to nodes"
	# ssh-keygen -f ~/.ssh/known_hosts -R $(KUBERNETES_IPS)
	./scripts/kubespray/run.sh

kubernetes-post-setup: kubernetes # Post setup for kubernetes
	@echo "Post setup for kubernetes"
	sed -i '' 's/127\.0\.0\.1/${KUBERNETES_PRIMARY_IP}/g' ansible/inventory/${KUBERNETES_CLUSTER_NAME}/artifacts/admin.conf

kubernetes: clean kubernetes-pre-setup kubernetes-post-setup # Install and configure kubernetes
	@echo "Installing and configuring kubernetes"

services-base: # Install services to kubernetes cluster using kustomize
	@echo "Installing base/essential services to kubernetes cluster"
	./scripts/kubernetes/kustomize.sh

services-argocd: # apply argocd manifests and let argocd deploy to kubernetes cluster
	@echo "Installing services via argocd to cluster"
	./scripts/kubernetes/argocd.sh

services: services-base services-argocd # Install services to kubernetes cluster using kustomize

# TODO:
#   - Add arr stack
#   - Add home assistant
#   - Add adguard home
#   - Add wireguard
#   - Add logging
#   - Add monitoring (grafana/loki)
#   - document node label for igpu, kernel update to linux-generic for drivers and norootsquash on nas for jellyfin share
#   - document comicvine api key for kapowarr
#   - document local storage for arr stack due to sqlite
#   - document /mnt/kubernetes nightly backup to nas
#   - document chown -R 1000:1000 /mnt/kubernetes for config moves with regards to arr stack

home: vms kubernetes services # Create VMs, install kubernetes and services
	@echo "Welcome home"
