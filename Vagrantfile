# Inspired by https://github.com/apache/kafka/blob/trunk/Vagrantfile
num_zookeepers = 1
num_brokers = 3
num_c3 = 1
zk_ram_mb = 1280
kafka_ram_mb = 1280
c3_ram_mb = 1280
base_box = "packer-cp"
base_box_url = "file://output-vagrant/package.box"

Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false

  ## Provider-specific global configs
  config.vm.provider :virtualbox do |vb,override|
    override.vm.box = base_box
    override.vm.box_url = base_box_url
  end

  def name_node(node, name)
    node.vm.hostname = name
  end
  
  def assign_local_ip(node, ip_address)
    node.vm.provider :virtualbox do |vb,override|
      override.vm.network :private_network, ip: ip_address
    end
  end

  def assign_ram_memory(node, ram_mb)
    node.vm.provider :virtualbox do |vb,override|
      # Brokers started with the standard script currently set Xms and Xmx to 1G,
      # plus we need some extra head room.
      vb.customize ["modifyvm", :id, "--memory", ram_mb]
    end
  end
  
  zookeepers = []
  (1..num_zookeepers).each { |i|
    name = "zk" + i.to_s
    zookeepers.push(name)
    config.vm.define name do |zookeeper|
      name_node(zookeeper, name)
      ip_address = "192.168.50." + (10 + i).to_s
      assign_local_ip(zookeeper, ip_address)
      assign_ram_memory(zookeeper, zk_ram_mb)
      # zookeeper.vm.provision "shell", path: "vagrant/base.sh", env: {"JDK_MAJOR" => jdk_major, "JDK_FULL" => jdk_full}
      # zk_jmx_port = enable_jmx ? (8000 + i).to_s : ""
      # zookeeper.vm.provision "shell", path: "vagrant/zk.sh", :args => [i.to_s, num_zookeepers, zk_jmx_port]
    end
  }

  brokers = []
  (1..num_brokers).each { |i|
    name = "broker" + i.to_s
    brokers.push(name)
    config.vm.define name do |broker|
      name_node(broker, name)
      ip_address = "192.168.50." + (50 + i).to_s
      assign_local_ip(broker, ip_address)
      assign_ram_memory(broker, kafka_ram_mb)
      # We need to be careful about what we list as the publicly routable
      # address since this is registered in ZK and handed out to clients. If
      # host DNS isn't setup, we shouldn't use hostnames -- IP addresses must be
      # used to support clients running on the host.
      zookeeper_connect = zookeepers.map{ |zk_addr| zk_addr + ":2181"}.join(",")
      broker.vm.post_up_message = "zookeeper.connect=" + zookeeper_connect
    end
  }
  
  (1..num_c3).each { |i|
    name = "ccc" + i.to_s
    config.vm.define name do |c3|
      name_node(c3, name)
      ip_address = "192.168.50." + (30 + i).to_s
      assign_local_ip(c3, ip_address)
      assign_ram_memory(c3, c3_ram_mb)
      # We need to be careful about what we list as the publicly routable
      # address since this is registered in ZK and handed out to clients. If
      # host DNS isn't setup, we shouldn't use hostnames -- IP addresses must be
      # used to support clients running on the host.
      zookeeper_connect = zookeepers.map{ |zk_addr| zk_addr + ":2181"}.join(",")
      bootstrap_servers = brokers.map{ |zk_addr| zk_addr + ":2181"}.join(",")
      c3.vm.post_up_message = "zookeeper.connect=" + zookeeper_connect + "\n" + "bootstrap.servers=" + bootstrap_servers
    end
  }
end