# -*- mode: ruby -*-
# vi: set ft=ruby :

# Puppet Enterprise Installer
PE_VERSION="puppet-enterprise-3.7.2-el-6-x86_64"
PE_BUNDLE="#{PE_VERSION}.tar.gz"

# Hostnames of systems
NAME_MASTER="master"
NAME_CA="ca"
NAME_CONSOLE="console"
NAME_PUPPETDB="puppetdb"
NAME_NODE="node"

# Group name (used in VirtualBox GUI)
GROUP="Puppet Enterprise"

# Managed nodes. The total cannot be greater than seven because of PE licensing.
# Number of Enterprise Linux managed nodes to create.
EL_INSTANCES=1

# Number of Windows 2012 
WIN_INSTANCES=1

# Domain for all nodes, i.e. "example.com". Defaults to "local".
# Changing this requires modifying the answer files.
DOMAIN="local"

# CPU settings for Puppet infrastructure and managed nodes
CPU_MASTER=2
CPU_CA=1
CPU_CONSOLE=2
CPU_PUPPETDB=2
CPU_NODE=1

# Memory settings for Puppet infrastructure and managed nodes
MEMORY_MASTER=3072
MEMORY_CA=512
MEMORY_CONSOLE=1024
MEMORY_PUPPETDB=2048
MEMORY_NODE=384

# Puppet configuration parameters
RUNINTERVAL="5m"
ENVIRONMENT_TIMEOUT="30s"


Vagrant.configure("2") do |config|
  config.vm.define NAME_MASTER, primary: true do |master|
    # Using a Chef-provided box for a Puppet installation. Ironic!
    master.vm.box = "chef/centos-6.6"
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine
    end
    master.vm.hostname = "#{NAME_MASTER}.#{DOMAIN}"
    master.vm.network "private_network", type: "dhcp"
    master.vm.provider "virtualbox" do |v|
      v.name = "Puppet Master"
      v.memory = MEMORY_MASTER
      v.cpus = CPU_MASTER
      v.customize [ 
        "modifyvm", :id,
        "--groups", "/#{GROUP}"
      ]
    end
    # This should all be refactored into a parameterized external script file that is shared between all Puppet VMs
    master.vm.provision "shell", inline: <<-SHELL
      sudo yum install --assumeyes epel-release
      sudo yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
      sudo service atd start
      sudo service iptables stop
      sudo service messagebus restart
      sudo service avahi-daemon restart
      sleep 3 # wait for avahi-daemon to discover other servers
      sudo tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
      sudo /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_MASTER}.answer
      sudo echo -e "autosign = true\n" >> /etc/puppetlabs/puppet/puppet.conf
      sudo /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      sudo /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      sudo service pe-puppetserver restart
      sudo service pe-puppet restart
    SHELL
  end

#   config.vm.define NAME_CA do |ca|
#     ca.vm.box = "chef/centos-6.6"
#     if Vagrant.has_plugin?("vagrant-cachier")
#       config.cache.scope = :machine
#     end
#     ca.vm.hostname = "#{NAME_CA}.#{DOMAIN}"
#     ca.vm.network "private_network", type: "dhcp"
#     ca.vm.provider "virtualbox" do |v|
#       v.name = "Puppet CA"
#       v.memory = MEMORY_CA
#       v.cpus = CPU_CA
#       v.customize [ 
#         "modifyvm", :id,
#         "--groups", "/#{GROUP}"
#       ]
#     end
#     ca.vm.provision "shell", inline: <<-SHELL
#       sudo yum install --assumeyes epel-release
#       sudo yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
#       sudo service atd start
#       sudo service iptables stop
#       sudo service messagebus restart
#       sudo service avahi-daemon restart
#       sleep 3 # wait for avahi-daemon to discover other servers
#       sudo tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
#       sudo /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_CA}.answer
#       sudo /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
#       sudo /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
#       sudo service pe-puppet restart
#     SHELL
#   end
  
  config.vm.define NAME_PUPPETDB do |puppetdb|
    puppetdb.vm.box = "chef/centos-6.6"
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine
    end
    puppetdb.vm.hostname = "#{NAME_PUPPETDB}.#{DOMAIN}"
    puppetdb.vm.network "private_network", type: "dhcp"
    puppetdb.vm.provider "virtualbox" do |v|
      v.name = "Puppet DB"
      v.memory = MEMORY_PUPPETDB
      v.cpus = CPU_PUPPETDB
      v.customize [ 
        "modifyvm", :id,
        "--groups", "/#{GROUP}"
      ]
    end
    puppetdb.vm.provision "shell", inline: <<-SHELL
      sudo yum install --assumeyes epel-release
      sudo yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
      sudo service atd start
      sudo service iptables stop
      sudo service messagebus restart
      sudo service avahi-daemon restart
      sleep 3 # wait for avahi-daemon to discover other servers
      sudo tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
      sudo /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_PUPPETDB}.answer
      sudo /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      sudo /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      sudo service pe-puppet restart
    SHELL
  end
  
  config.vm.define NAME_CONSOLE do |console|
    console.vm.box = "chef/centos-6.6"
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine
    end
    console.vm.hostname = "#{NAME_CONSOLE}.#{DOMAIN}"
    console.vm.network "private_network", type: "dhcp"
    console.vm.post_up_message = "Puppet Enterprise is now running. Access the console at '\033[36mhttp://console.local\033[32m'."
    console.vm.provider "virtualbox" do |v|
      v.name = "Puppet Console"
      v.memory = MEMORY_CONSOLE
      v.cpus = CPU_CONSOLE
      v.customize [ 
        "modifyvm", :id,
        "--groups", "/#{GROUP}"
      ]     
    end
    console.vm.provision "shell", inline: <<-SHELL
      sudo yum install --assumeyes epel-release
      sudo yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
      sudo service atd start
      sudo service iptables stop
      sudo service messagebus restart
      sudo service avahi-daemon restart
      sleep 3 # wait for avahi-daemon to discover other servers
      sudo tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
      sudo /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_CONSOLE}.answer
      sudo /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      sudo /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      sudo service pe-puppet restart
    SHELL
  end

  EL_INSTANCES.times do |i|
    config.vm.define "el-node#{i}".to_sym do |node|
      node.vm.box = "chef/centos-6.6"
      if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :machine
      end
      node.vm.hostname = "el-node#{i}.#{DOMAIN}"
      node.vm.network "private_network", type: "dhcp"
      node.vm.provider "virtualbox" do |v|
        v.name = "PE-Managed EL Node #{i}"
        v.memory = MEMORY_NODE
        v.cpus = CPU_NODE
        v.customize [
          "modifyvm", :id,
          "--groups", "/#{GROUP}"
        ]
      end
      node.vm.provision "shell", inline: <<-SHELL
      sudo yum install --assumeyes epel-release
      sudo yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns
      sudo service iptables stop
      sudo service messagebus restart
      sudo service avahi-daemon restart
      sleep 3 # wait for avahi-daemon to discover other servers
      curl -k https://master.local:8140/packages/current/install.bash | sudo bash
      sudo /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      sudo /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      sudo service pe-puppet restart
      SHELL
    end
  end
  
  WIN_INSTANCES.times do |i|
    config.vm.guest = :windows
    config.vm.communicator = "winrm"
    config.winrm.timeout = 500
    config.vm.define "win-node#{i}".to_sym do |node|
      node.vm.box = "windows"
      node.vm.hostname = "win-node#{i}.#{DOMAIN}"
      node.vm.network "private_network", type: "dhcp"
      node.vm.provider "virtualbox" do |v|
        v.name = "PE-Managed Windows Node #{i}"
        v.memory = MEMORY_NODE
        v.cpus = CPU_NODE
        v.customize [
          "modifyvm", :id,
          "--groups", "/#{GROUP}"
        ]
      end
#      node.vm.provision "shell", inline: <<-SHELL
#      sudo yum install --assumeyes epel-release
#      sudo yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns
#      sudo service iptables stop
#      sudo service messagebus restart
#      sudo service avahi-daemon restart
#      sleep 3 # wait for avahi-daemon to discover other servers
#      curl -k https://master.local:8140/packages/current/install.bash | sudo bash
#      sudo /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
#      sudo /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
#      sudo service pe-puppet restart
#      SHELL
    end
  end

end
