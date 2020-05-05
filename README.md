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
==> broker1: Machine 'broker1' has a post `vagrant up` message. This is a message
==> broker1: from the creator of the Vagrantfile, and not from Vagrant itself:
==> broker1: 
==> broker1: zookeeper.connect=zk1:2181,zk2:2181,zk3:2181

==> broker2: Machine 'broker2' has a post `vagrant up` message. This is a message
==> broker2: from the creator of the Vagrantfile, and not from Vagrant itself:
==> broker2: 
==> broker2: zookeeper.connect=zk1:2181,zk2:2181,zk3:2181

==> broker3: Machine 'broker3' has a post `vagrant up` message. This is a message
==> broker3: from the creator of the Vagrantfile, and not from Vagrant itself:
==> broker3: 
==> broker3: zookeeper.connect=zk1:2181,zk2:2181,zk3:2181

==> c3-1: Machine 'c3-1' has a post `vagrant up` message. This is a message
==> c3-1: from the creator of the Vagrantfile, and not from Vagrant itself:
==> c3-1: 
==> c3-1: zookeeper.connect=zk1:2181,zk2:2181,zk3:2181
==> c3-1: bootstrap.servers=broker1:2181,broker2:2181,broker3:2181
```

When finished, destroy VMs if not needed any more:

```bash
vagrant destroy -f
```
