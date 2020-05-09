.PHONY: all
all:

.PHONY: add_vagrant_box
add_vagrant_box:
	vagrant box add ubuntu/bionic64

.PHONY: build_vagrant_box
build_vagrant_box:
	packer build -only=vagrant main.json

.PHONY: build_aws_ami
build_aws_ami:
	packer build -only=amazon-ebs -var aws_user=${USER} main.json

.PHONY: prereq_vagrant
prereq_vagrant:
	vagrant plugin install vagrant-hostmanager