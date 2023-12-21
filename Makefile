SHELL := /bin/bash
include .env

help: # Show the function of different make targets
	@echo "Available targets:"
	@echo "  help       : Show the function of different make targets"
	@echo "  vms        : Create VMs in proxmox with terraform"
	@echo "  kubernetes : Uses kubespray to install kubernetes to nodes"
	@echo "  services   : Install services to kubernetes cluster using kustomize"
	@echo "  clean      : Clean up the local environment"


clean: # Clean up the local environment
	@echo "Cleaning up the local environment"

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

kubernetes: # Install kubernetes to VMs
	@echo "Installing kubernetes to nodes"
	ssh-keygen -f "~/.ssh/known_hosts" -R $(PROXMOX_IPS)
	./scripts/kubespray/run.sh

services: # Install services to kubernetes cluster using kustomize
	@echo "Installing services to kubernetes cluster"
