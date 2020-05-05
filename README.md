# Confluent Platform first cluster

## Vagrant with VirtualBox


Download Vagrant box to prepare base image:

```bash
make add_vagrant_box
```

Build Vagrant base image:

```bash
make build_vagrant_box
```

Install Vagrant plugins (if not installed already):

```bash
make prereq_vagrant
```

Then use `vagrant` commands as usual:

```bash
vagrant up
#...

```

When finished, destroy VMs if not needed any more:

```bash
vagrant destroy -f
```
