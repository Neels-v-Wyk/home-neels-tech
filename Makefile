
help: # Show the function of different make targets
	@echo "Available targets:"
	@echo "  help    : Show the function of different make targets"
	@echo "  secrets : Source secrets from secrets.env"
	@echo "  vms     : Create VMs in proxmox"
	@echo "  test    : Do c"

secrets: # Source secrets from secrets.env 
	@echo "Sourcing secrets from secrets.env"	
	set -o allexport
	source secrets.env
	set +o allexport

vms: # Create VMs in proxmox
	@echo "Creating VMs in proxmox"

