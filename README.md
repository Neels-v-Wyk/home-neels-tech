# Welcome home :)

This repo serves as a way to document the layout and configuration of my home infrastructure, and it also acts as the main source of truth for config files, infrastructure as code, network info, etc.

## Deployment

### Prerequisites

1. A `secrets.env` file filled out. Copy `example-secrets.env` for a base
2. terraform
3. ansible
4. A Corpse Reviver No. 2

### Process
Currently, all manual setup documentation can be found in `setup/`, it outlines everything you need to do to get the hosts in a usable state and assumes you are starting from scratch.

From there, everything else is handled in code. Initial VM creation is handled by terraform, kubernetes installation is handled by kubespray, and the rest (MetalLB, services) are handled by kustomize.

Each step should be idempotent and you can use the `makefile` to set everything up.

### Kubernetes cluster configuration
If you wish to make additions/deletions in the kubernetes cluster, make changes in `ansible/inventory/hosts.yaml` and `ansible/inventory/cluster.yaml` followed by `make kubernetes` in order to have your changes reflected

## Physical infrastructure
![physical infrastructure](https://github.com/Neels-v-Wyk/home-neels-tech/blob/master/diagrams/home-physical.png?raw=true)
