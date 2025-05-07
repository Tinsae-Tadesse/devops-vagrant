# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # This configures what box the machine will be brought up against. 
  config.vm.box = "hashicorp/bionic64"
  
  # The version of the box to use.
  config.vm.box_version = "1.0.282"
  
  config.vm.define "web-server" do |web|
    
	# The hostname the machine should have. 
	web.vm.hostname = "web-vm.local"

	# Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine. 
	web.vm.network "forwarded_port", guest: 80, host: 3030

	# Create a private network, which allows host-only access to the machine
	# using a specific IP.
	web.vm.network "private_network", ip: "192.168.33.10"

	# Create a public network, which generally matched to bridged network.
	# Bridged networks make the machine appear as another physical device on
	# your network.
	web.vm.network "public_network", ip: "10.0.0.1", hostname: true

	# Share an additional folder to the guest VM. The first argument is
	# the path on the host to the actual folder. The second argument is
	# the path on the guest to mount the folder. And the optional third
	# argument is a set of non-required options.
	# config.vm.synced_folder "../data", "/vagrant_data"

	# Disable the default share of the current code directory. Doing this
	# provides improved isolation between the vagrant box and your host
	# by making sure your Vagrantfile isn't accessible to the vagrant box.
	# If you use this you may want to enable additional shared subfolders as
	# shown above.
	# config.vm.synced_folder ".", "/vagrant", disabled: true

	# Provider-specific configuration so you can fine-tune various
	# backing providers for Vagrant. These expose provider-specific options.
	# Example for VirtualBox:
	#
	# config.vm.provider "virtualbox" do |vb|
	#   # Display the VirtualBox GUI when booting the machine
	#   vb.gui = true
	#
	#   # Customize the amount of memory on the VM:
	#   vb.memory = "1024"
	# end
	#
	# View the documentation for the provider you are using for more
	# information on available options.

	# Enable provisioning with a shell script.
	web.vm.provision "bootstrap-config", type: "shell" do |script|
		script.path = "./vagrant-scripts/provisioning.sh"
	end
  end
end
