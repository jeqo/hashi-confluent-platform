# hashi-confluent-platform

## Why Packer

> Docker image builder but for all machines 

Packer is a tool created by Hashicorp to create machine images on different formats and platforms.

- Similar to `docker build` command, `packer build`  creates a machine image
- Similar to Dockerfile `FROM base`, packer `builder` chooses platform (e.g. virtualbox, docker, amazon ami) and base image
- Similar to Dockerfile commands, packer provisioners add configuration and libraries to the base image