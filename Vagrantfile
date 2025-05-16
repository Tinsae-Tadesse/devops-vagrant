# -*- mode: ruby -*-
# vi: set ft=ruby :

db_host = "192.168.56.12"
db_user = "myuser"
db_pass = "mypassword"
db_name = "myapp"

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
    web.hostmanager.aliases = %w(web.example.local web-vm.local)

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
		  script.path = "./vagrant-scripts/web-provisioning.sh"
		  script.args = [db_host, db_user, db_pass, db_name]
	  end
  end
  
  # Database Server VM
  config.vm.define "db-server" do |db|
    # The hostname the machine should have. 
	  db.vm.hostname = "db-vm"
	  
	  # Configure subdomain pattern
    db.hostmanager.aliases = %w(db.example.local db-vm.local)
	  
    # Create a private network, which allows host-only access to the machine
	  # using a specific IP.
	  db.vm.network "private_network", ip: "192.168.56.12"
	  
	  # Provider-specific configurations: such as memory allocation.
	  db.vm.provider "virtualbox" do |vb|
	     vb.memory = "1024"
	     vb.name = "db-server"
	  end

    # Enable provisioning with a Shell script.
	  db.vm.provision "bootstrap-config", type: "shell" do |script|
		  script.path = "./vagrant-scripts/db-provisioning.sh"
		  script.args = [db_host]
	  end
  end
end
