# Confluent Platform first cluster

## Checklist

1. Choose to start your environment ...
    1. with Packer, Vagrant and VirtualBox
    2. with Packer, Terraform and AWS //TODO
2. Follow installation steps

## Required software

* Packer
* Vagrant[1.1]
* VirtualBox[1.1]
* Terraform[1.2]
* Ansible

## Start environment with Vagrant and VirtualBox

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

To add IPs to hosts file:

```bash
vagrant hostmanager
```

When finished, destroy VMs if not needed any more:

```bash
vagrant destroy -f
```

## Start environment with Terraform and AWS

Build Amazon AMI:

```bash
make build_aws_ami
```

A new AMI should be created on AWS with the following format:
`{{username}}-cp {{timestamp}}`

Initialize Terraform tools:

```bash
terraform init
```

And provision AWS instances:

```bash
terraform apply -var user=... -var key_name=... -var ami=from_packer_output
```

When finished, destroy resources:

```bash
terraform destroy
```

## Installation steps

Check connection via Ansible:

```bash
ansible-playbook -i enviroments/virtualbox.yml ping.yml
# or
ansible-playbook -i enviroments/aws.yml ping.yml
```

> For AWS, create an inventory file based on `environments/aws_template.yml` and the outputs from Terraform. 

### Configure and start Zookeeper

Explore [`zookeeper.yml` playbook](./zookeeper.yml) and run the playbook:

```bash
ansible-playbook -i enviroments/virtualbox.yml zookeeper.yml
# or
ansible-playbook -i enviroments/aws.yml zookeeper.yml
```

Expected result: Zookeeper nodes started and ensemble created.

Validation:

```bash
$CONFLUENT_HOME/bin/zookeeper-shell zk1:2181 get /zookeeper/config
```

### Configure and Start Kafka brokers

Explore [`brokers.yml` playbook](./brokers.yml) and run the playbook:

```bash
ansible-playbook -i enviroments/virtualbox.yml brokers.yml
# or
ansible-playbook -i enviroments/aws.yml brokers.yml
```

Expected result: Kafka brokers started and cluster up and running.

Validation:

```bash
$CONFLUENT_HOME/bin/kafka-topics --bootstrap-server broker1:9092 \
--create \
--topic test \
--replication-factor 3 \
--partitions 8
```

```bash
$CONFLUENT_HOME/bin/kafka-topics --bootstrap-server broker1:9092 --describe --topic test
Topic: test    PartitionCount: 8       ReplicationFactor: 3    Configs: segment.bytes=1073741824
        Topic: test    Partition: 0    Leader: 1       Replicas: 1,3,2 Isr: 1,3,2   Offline: 
        Topic: test    Partition: 1    Leader: 2       Replicas: 2,1,3 Isr: 2,1,3   Offline: 
        Topic: test    Partition: 2    Leader: 3       Replicas: 3,2,1 Isr: 3,2,1   Offline: 
        Topic: test    Partition: 3    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3   Offline: 
        Topic: test    Partition: 4    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1   Offline: 
        Topic: test    Partition: 5    Leader: 3       Replicas: 3,1,2 Isr: 3,1,2   Offline: 
        Topic: test    Partition: 6    Leader: 1       Replicas: 1,3,2 Isr: 1,3,2   Offline: 
        Topic: test    Partition: 7    Leader: 2       Replicas: 2,1,3 Isr: 2,1,3   Offline: 
```
