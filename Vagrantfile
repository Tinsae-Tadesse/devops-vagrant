# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # This configures what box the machine will be brought up against. 
  config.vm.box = "hashicorp/bionic64"
  
  # The version of the box to use.
  config.vm.box_version = "1.0.282"
  
  # Configure top level domain
  config.dns.tld = "tinsae.com"
  
  config.vm.define "web-server" do |web|
  
	# Provider-specific configurations: such as memory allocation.
	web.vm.provider "virtualbox" do |vb|
	   vb.memory = "1024"
	end
    
	# The hostname the machine should have. 
	web.vm.hostname = "web-vm"
	
	# Configure subdomain pattern
	web.dns.pattern = [/^web-vm.tinsae.com$/]

	# Create a forwarded port mapping which allows access to a specific port
	# within the machine from a port on the host machine. 
	web.vm.network "forwarded_port", guest: 80, host: 3030

	# Create a private network, which allows host-only access to the machine
	# using a specific IP.
	web.vm.network "private_network", ip: "10.11.12.13"
	
	# Enable provisioning with a Shell script.
	web.vm.provision "bootstrap-config", type: "shell" do |script|
		script.path = "./vagrant-scripts/provisioning.sh"
	end
  end
end
