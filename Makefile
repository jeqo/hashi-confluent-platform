.PHONY: all
all:

.PHONY: add_vagrant_box
add_vagrant_box:
	vagrant box add ubuntu/bionic64

.PHONY: build_vagrant_box
build_vagrant_box:
	packer build --only=vagrant main.json

.PHONY: prereq_vagrant
prereq_vagrant:
	vagrant plugin install vagrant-hostmanager

.PHONY: start_vagrant
start_vagrant:
	vagrant up