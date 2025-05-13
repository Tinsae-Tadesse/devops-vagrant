# Hosting a Website with Vagrant, Apache2, and vagrant-hostmanager

## Overview
This guide walks you through creating a portable development environment using **Vagrant**, serving a static website via **Apache2**, and managing local DNS entries automatically using the **vagrant-hostmanager** plugin. Your website content will be cloned from a **GitHub repository** directly into the VM and served via Apache2.

## ✅ Prerequisites
Before starting, make sure the following tools are installed on your local machine:
- [ ] Install [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [ ] Install [Vagrant](https://developer.hashicorp.com/vagrant/install)
- [ ] Install [Vagrant Hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) plugin for managing local name entries:
```
vagrant plugin install vagrant-hostmanager
```

---

## 📁 Project Directory Structure
Create a new directory for your project:
```
my-static-site/
├── assets/
├── images/
├── vagrant-scripts/
├── vagrant-scripts/provision.sh
├── index.html
├── Vagrantfile
```
- `Vagrantfile`: Configuration file for the vagrant virtual machine
- `vagrant-scripts/provision.sh`: Shell script to provision Apache2 and fetch your site content

---

## Implementation
### 🔧 Step 1: Create the Vagrantfile
Create a Vagrantfile with the following content:
```
Vagrant.configure("2") do |config|
  # Configure base OS image
  config.vm.box = "ubuntu/bionic64"

  # Configure host manager for DNS resolution 
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  
  config.vm.define "web-server" do |web|
    # Hostname used inside the VM and on the host machine
    web.vm.hostname = "web-vm"
    
    # Configure subdomain pattern
    web.hostmanager.aliases = %w(web-vm.example.local web-vm.local)
    
    # Assign a private IP to the VM
    web.vm.network "private_network", ip: "192.168.56.10"
    
    # Create a forwarded port mapping between the host and guest machine ports
    web.vm.network "forwarded_port", guest: 80, host: 1234
    
    # Provider-specific configurations: such as memory allocation.
    web.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "web-server"
    end

    # Configure provisioning through a Shell script
    web.vm.provision "bootstrap-config", type: "shell" do |script|
      script.path = "./vagrant-scripts/provision.sh"
    end
  end
end
```

---

### ⚙️ Step 2: Write the provision.sh Script
This script installs Apache2, clones your GitHub repository into the web root, and restarts Apache.
```
#!/usr/bin/env bash

# Stop on first error
set -e

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Install Apache and Git
echo "Installing Apache2 and Git..."
sudo apt-get install -y apache2 git

# Define target directory and GitHub repo
WEB_ROOT="/var/www/my-static-site"
REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"

# Clean the web root and clone your repo
echo "Cloning website repository..."
sudo rm -rf $WEB_ROOT
git clone $REPO_URL
sudo mkdir $WEB_ROOT
sudo mv ./YOUR_REPO_NAME/* $WEB_ROOT
sudo rm -rf ./YOUR_REPO_NAME

# Set permissions
echo "Setting file permissions..."

# Configure setting
echo "Configuring setting..."
sudo echo """
<VirtualHost *:80>
    ServerName web-vm.example.local
    DocumentRoot $WEB_ROOT
    <Directory $WEB_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
""" > /etc/apache2/sites-available/my-static-site.conf
chown -R www-data:www-data $WEB_ROOT

# Restart Apache
echo "Restarting Apache2..."
systemctl restart apache2
sudo a2dissite /etc/apache2/sites-available/000-default.conf
sudo a2ensite /etc/apache2/sites-available/my-static-site.conf

echo "Provisioning complete. Static site is ready!"
```

---

## 🌐 Accessing the Website

## Getting started

To make it easy for you to get started with this GitHub repository, follow the below list of recommended next steps.

## Add your files

- [ ] Clone this repository and tell `git` start tracking changes.
```
git clone https://gitlab.com/tinsaetadesse2015/devops-git.git
cd devops-git
git init --initial-branch=dev
git add --all
```
- [ ] Apply the neccessary changes to the cloned files and push the new change to an existing Git repository.
```
git remote add origin https://github.com/Tinsae-Tadesse/devops-git.git
git commit --message "initial commit"
git push -u origin dev
```
- [ ] If the above push fails, due to commit differences between local and remote repos, then do the following.
```
git pull origin dev --allow-unrelated-histories
git commit --message "fixed issue"
git push -u origin dev
```

