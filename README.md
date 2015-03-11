# Vagrant-based Puppet-Enterprise Split Installation

This project is used for creating a small split installation of Puppet Enterprise for testing and evaluation purposes. It is not suitable for production use. A split installation installs Puppet Master, PuppetDB, and Console on separate servers and is a recommended architecture for scalability. A future version will further split the installation by installing the Certificate Authority and Puppet Master on separate nodes.


## Requirements

You must have:
- Vagrant
- VirtualBox
- Sufficient RAM to run the VMs. By default, the VMs are configured with 7.25 GiB (total) of RAM. Having at least 10 GiB of RAM installed in your host machine is advisable to avoid swapping. You can adjust the VM RAM settings in the Vagrantfile, however some Puppet components may not perform adequately with lower amounts.
- A Zeroconf/Bonjour client running on your host machine (i.e. your laptop). Any Mac running OS X already has this. For Windows, try Apple's [Bonjour Print Services](https://support.apple.com/kb/DL999?locale=en_US), which installs the required components. On Linux, install Avahi/mDNS.

The Vagrantfile supports the [`vagrant-cachier`](https://github.com/fgrehm/vagrant-cachier) plugin to cache yum repositories for faster startup. It is not required but can considerably reduce  ```vagrant up``` times during subsequent runs because each of the Puppet infrastructure nodes perform several ```yum``` operations.


## How to Use

Clone this repository, and ```cd``` to the repo directory. To download the Puppet Enterprise installer the first time, run the run_first.sh script by typing ```./run_first.sh```. Once that completes, just run ```vagrant up``` to get started. Once the VMs have launched, you can run ```vagrant ssh``` to connect to the Puppet Master. To access the Puppet Enterprise Console, point your browser to https://console.local. The username is ```admin``` and the password is ```puppetpassword```. (The password can be changed in the answer files in this repository.)


## Troubleshooting

Here are some common problems you may encounter:

### I can't run the ```run_first.sh``` script!

Make sure the script is executable. From your project repo directory, run ```chmod +x run_first.sh```. Then execute the script as normal.

### My computer slows to a crawl when I run ```vagrant up```!

Your computer probably doesn't have enough memory to run all of the VMs concurrently. Try adjusting the RAM settings in the Vagrantfile. The parameters names all start with "```MEMORY_```" followed by the role of the VM. You may adjust the number of virtual CPU cores each VM gets with the "```CPU_```" parameters. You can also reduce the number of managed nodes with the ```INSTANCES``` parameter.


## Future Enhancements

- Add option to provision to AWS instead of VirtualBox.