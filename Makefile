SHELL := /bin/bash
include .env

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

kubernetes: # Install kubernetes to VMs
	@echo "Installing kubernetes to nodes"
	# ssh-keygen -f ~/.ssh/known_hosts -R $(KUBERNETES_IPS)
	./scripts/kubespray/run.sh

services: # Install services to kubernetes cluster using kustomize
	@echo "Installing services to kubernetes cluster"
	# TODO:
	# 	- Add kustomize
	#   - Add Argocd
	# 	- Add ingress
	# 	- Add metallb
	# 	- Add cert-manager
	#   - Add jellyfin
	#   - Add arr stack
	#   - Add home assistant
	#   - Add pihole
	#   - Add wireguard

home: vms kubernetes services # Create VMs, install kubernetes and services
	@echo "Welcome home"
