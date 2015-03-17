# -*- mode: ruby -*-
# vi: set ft=ruby :

PUPPET_ENTERPRISE_VERSION="3.7.2"

URL="https://s3.amazonaws.com/ddig-puppet/"
PE_INSTALLER="puppet-enterprise-#{PUPPET_ENTERPRISE_VERSION}-el-6-x86_64.tar.gz"
PE_WIN_AGENT="puppet-enterprise-#{PUPPET_ENTERPRISE_VERSION}-x64.msi"
BONJOUR_WIN_CLIENT="Bonjour64.msi"

EL_BOX="puppetlabs/centos-6.6-64-nocm"
WIN_BOX="chrisbelyea/windows2012r2core"

# Check for required installers and download if missing
if ! File.exists?('./bin')
  printf "The 'bin' directory was not found, creating it..."
  require 'fileutils'
  FileUtils.mkdir_p './bin'
  puts "done."
end

if ! File.exists?("./bin/#{PE_INSTALLER}")
  puts "\033[31mPuppet Enterprise installer could not be found!\033[39m."
  printf "Downloading #{URL}/#{PE_INSTALLER} (be patient!)..."
  #puts "Please run '\033[36m./run_first.sh\033[39m' to download required dependencies."
  require 'open-uri'
  File.open("./bin/#{PE_INSTALLER}", "wb") do |saved_file|
    open("#{URL}#{PE_INSTALLER}", "rb") do |read_file|
      saved_file.write(read_file.read)
    end
  end
  puts "done."
  #exit 1
end

if ! File.exists?("./bin/#{PE_WIN_AGENT}")
  puts "\033[31mPuppet Enterprise Windows agent installer could not be found!\033[39m."
  printf "Downloading #{URL}/#{PE_WIN_AGENT} (be patient!)..."
  #puts "Please run '\033[36m./run_first.sh\033[39m' to download required dependencies."
  require 'open-uri'
  File.open("./bin/#{PE_WIN_AGENT}", "wb") do |saved_file|
    open("#{URL}#{PE_WIN_AGENT}", "rb") do |read_file|
      saved_file.write(read_file.read)
    end
  end
  puts "done."
  #exit 1
end

if ! File.exists?("./bin/#{BONJOUR_WIN_CLIENT}")
  puts "\033[31mBonjour installer could not be found!\033[39m."
  printf "Downloading #{URL}/#{BONJOUR_WIN_CLIENT} (be patient!)..."
  #puts "Please run '\033[36m./run_first.sh\033[39m' to download required dependencies."
  require 'open-uri'
  File.open("./bin/#{BONJOUR_WIN_CLIENT}", "wb") do |saved_file|
    open("#{URL}#{BONJOUR_WIN_CLIENT}", "rb") do |read_file|
      saved_file.write(read_file.read)
    end
  end
  puts "done."
  #exit 1
end

# Puppet Enterprise Installer
PE_VERSION="puppet-enterprise-3.7.2-el-6-x86_64"
PE_BUNDLE="./bin/#{PE_VERSION}.tar.gz"

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

# Domain for all nodes, i.e. "example.com". Defaults to "local" for support with
# Zeroconf (Avahi)/Bonjour. If you change this, ensure that a reliable DNS source
# is available and configured.
# Changing this requires modifying the answer files.
DOMAIN="local"

# CPU settings for Puppet infrastructure and managed nodes
CPU_MASTER=2
CPU_CA=1
CPU_CONSOLE=1
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

# Pause after Avahi startup
AVAHI_DELAY="10"


Vagrant.configure("2") do |config|
  config.vm.define NAME_MASTER, primary: true do |master|
    master.vm.box = EL_BOX
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
      yum upgrade --assumeyes ca-certificates
      yum install --assumeyes epel-release
      yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
      service atd start
      service iptables stop
      service messagebus restart
      service avahi-daemon restart
      sleep #{AVAHI_DELAY} # wait for avahi-daemon to discover other servers
      tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
      /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_MASTER}.answer
      echo -e "autosign = true\n" >> /etc/puppetlabs/puppet/puppet.conf
      /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      service pe-puppetserver restart
      service pe-puppet restart
    SHELL
  end

#   config.vm.define NAME_CA do |ca|
#     ca.vm.box = EL_BOX
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
#       yum upgrade --assumeyes ca-certificates
#       yum install --assumeyes epel-release
#       yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
#       service atd start
#       service iptables stop
#       service messagebus restart
#       service avahi-daemon restart
#       sleep #{AVAHI_DELAY} # wait for avahi-daemon to discover other servers
#       tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
#       /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_CA}.answer
#       /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
#       /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
#       service pe-puppet restart
#     SHELL
#   end
  
  config.vm.define NAME_PUPPETDB do |puppetdb|
    puppetdb.vm.box = EL_BOX
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
      yum upgrade --assumeyes ca-certificates
      yum install --assumeyes epel-release
      yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
      service atd start
      service iptables stop
      service messagebus restart
      service avahi-daemon restart
      sleep #{AVAHI_DELAY} # wait for avahi-daemon to discover other servers
      tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
      /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_PUPPETDB}.answer
      /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      service pe-puppet restart
    SHELL
  end
  
  config.vm.define NAME_CONSOLE do |console|
    console.vm.box = EL_BOX
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :machine
    end
    console.vm.hostname = "#{NAME_CONSOLE}.#{DOMAIN}"
    console.vm.network "private_network", type: "dhcp"
    # If the Puppet Console credentials are changed in the answer file they must also be changed in the message below
    console.vm.post_up_message = "Puppet Enterprise is now running. Access the console at '\033[36mhttp://console.local\033[32m'. The username is '\033[34madmin\033[32m' and the password is '\033[34mpuppetpassword\033[32m'."
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
      yum upgrade --assumeyes ca-certificates
      yum install --assumeyes epel-release
      yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns at
      service atd start
      service iptables stop
      service messagebus restart
      service avahi-daemon restart
      sleep #{AVAHI_DELAY} # wait for avahi-daemon to discover other servers
      tar --extract --ungzip --file=/vagrant/#{PE_BUNDLE} -C /tmp/
      /tmp/#{PE_VERSION}/puppet-enterprise-installer -A /vagrant/#{NAME_CONSOLE}.answer
      /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      service pe-puppet restart
      echo -e "<?xml version=\"1.0\" standalone='no'?><\!--*-nxml-*-->\n<\!DOCTYPE service-group SYSTEM "avahi-service.dtd">\n\n<service-group>\n\n\t<name replace-wildcards=\"yes\">Puppet Enterprise Console (%h)</name>\n\n\t<service>\n\t\t<type>_https._tcp</type>\n\t\t<port>443</port>\n\t</service>\n\n</service-group>\n" >> /etc/avahi/services/console.service
    SHELL
  end

  EL_INSTANCES.times do |i|
    config.vm.define "el-node#{i}".to_sym do |elnode|
      elnode.vm.box = EL_BOX
      if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :machine
      end
      elnode.vm.hostname = "el-node#{i}.#{DOMAIN}"
      elnode.vm.network "private_network", type: "dhcp"
      elnode.vm.provider "virtualbox" do |v|
        v.name = "PE-Managed EL Node #{i}"
        v.memory = MEMORY_NODE
        v.cpus = CPU_NODE
        v.customize [
          "modifyvm", :id,
          "--groups", "/#{GROUP}"
        ]
      end
      elnode.vm.provision "shell", inline: <<-SHELL
      yum upgrade --assumeyes ca-certificates
      yum install --assumeyes epel-release
      yum install --assumeyes avahi avahi-compat-libdns_sd nss-mdns
      service iptables stop
      service messagebus restart
      service avahi-daemon restart
      sleep #{AVAHI_DELAY} # wait for avahi-daemon to discover other servers
      curl -k https://master.local:8140/packages/current/install.bash | sudo bash
      /usr/local/bin/puppet config set environment_timeout #{ENVIRONMENT_TIMEOUT} --section master
      /usr/local/bin/puppet config set runinterval #{RUNINTERVAL} --section agent
      service pe-puppet restart
      SHELL
    end
  end
  
  WIN_INSTANCES.times do |i|
    config.vm.define "win-node#{i}".to_sym do |winnode|
      winnode.vm.guest = :windows
      winnode.vm.communicator = "winrm"
      winnode.winrm.timeout = 500
      winnode.vm.box = WIN_BOX
      winnode.vm.hostname = "win-node#{i}.#{DOMAIN}"
      winnode.vm.network "private_network", type: "dhcp"
      winnode.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
      winnode.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
      winnode.vm.provider "virtualbox" do |v|
        v.name = "PE-Managed Windows Node #{i}"
        v.memory = MEMORY_NODE
        v.cpus = CPU_NODE
        v.customize [
          "modifyvm", :id,
          "--groups", "/#{GROUP}"
        ]
      end
      #winnode.vm.provision :shell, inline: "Restart-Computer"
      winnode.vm.provision :shell, path: "./scripts/Install-BonjourClient.ps1"
      winnode.vm.provision "shell" do |s|
        s.path = "./scripts/Install-PuppetEnterpriseAgent.ps1"
        s.args = "#{NAME_MASTER}.#{DOMAIN}"
      end
    end
  end

end
