# Welcome home :)

This repo serves as a way to document the layout and configuration of my home infrastructure, and it also acts as the main source of truth for config files, infrastructure as code, network info, etc.

## Deployment
Currently, all manual setup documentation can be found in `setup/`, it outlines everything you need to do to get the hosts in a usable state and assumes you are starting from scratch.

From there, everything else is handled in code. Initial VM creation is handled by terraform, kubernetes installation is handled by kubespray, and the rest (MetalLB, services) are handled by kustomize.

Each step should be idempotent and you can use the `makefile` to set everything up.

## Physical infrastructure
![physical infrastructure](https://github.com/Neels-v-Wyk/home-neels-tech/blob/master/diagrams/home-physical.png?raw=true)
