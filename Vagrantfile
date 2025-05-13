# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # This configures what box the machine will be brought up against. 
  config.vm.box = "hashicorp/bionic64"
  
  # The version of the box to use.
  config.vm.box_version = "1.0.282"

  # Configure host manager for DNS resolution 
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  
  config.vm.define "web-server" do |web|
  
    # The hostname the machine should have. 
	  web.vm.hostname = "web-vm"
    
    # Configure subdomain pattern
    web.hostmanager.aliases = %w(web-vm.example.local web-vm-alias)

	  # Create a forwarded port mapping which allows access to a specific port
	  # within the machine from a port on the host machine. 
	  web.vm.network "forwarded_port", guest: 80, host: 1234

	  # Create a private network, which allows host-only access to the machine
	  # using a specific IP.
	  web.vm.network "private_network", ip: "192.168.56.10"
	    
	  # Provider-specific configurations: such as memory allocation.
	  web.vm.provider "virtualbox" do |vb|
	     vb.memory = "1024"
	     vb.name = "web-server"
	  end
	  
	  # Enable provisioning with a Shell script.
	  web.vm.provision "bootstrap-config", type: "shell" do |script|
		  script.path = "./vagrant-scripts/provisioning.sh"
	  end
  end
end
