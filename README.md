# 🧰 Hosting a LAMP (Linux, Apache, MySQL, and PHP) Stack Website Using Vagrant

## Overview
This guide walks you through creating a portable LAMP stack development environment using **Vagrant**. It provisions separate virtual machines for the web server **(Apache2 + PHP)** and the database **(MySQL)**, with local DNS resolution managed automatically by the **vagrant-hostmanager** plugin. Website content is cloned from a **GitHub** repository into the web server VM and served through Apache2 with dynamic PHP processing and database interaction via MySQL.

## 📦 Architecture Overview
- [ ] Web VM (Apache + PHP):
- Hosts the frontend website
- Connects to DB VM using PHP (mysqli)

- [ ] Database VM (MySQL):
- Stores website data
- Accepts remote connections from Web VM

- [ ] Uses vagrant-hostmanager to define local hostnames (e.g., web.example.local)

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
│   ├── js/
│   │   ├── contact.js
├── images/
├── server-scripts/
│   ├── config.php.template   # modified on provisioning
│   ├── contact.php
│   ├── db-connect.php
├── vagrant-scripts/
│   ├── web_provision.sh
│   ├── db_provision.sh
├── index.html
├── Vagrantfile
```
- `Vagrantfile`: Configuration file for the vagrant virtual machines
- `vagrant-scripts/web_provision.sh`: Shell script to provision Apache2 + PHP and fetch site content
- `vagrant-scripts/db_provision.sh`: Shell script to provision MySQL

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
SITE_NAME="my-static-site"
WEB_ROOT="/var/www/$SITE_NAME"
SITE_CONF_DIR="/etc/apache2/sites-available"
REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"

# Stop Apache2 Service
echo "Stoping Apache2 Service..."
sudo systemctl stop apache2.service

# Clean the web root and clone your repo
echo "Cloning website repository..."
git clone $REPO_URL $SITE_NAME
sudo mv $SITE_NAME /var/www/

# Configure setting
echo "Configuring setting..."
echo """
<VirtualHost *:80>
    ServerName $SITE_NAME
    DocumentRoot $WEB_ROOT
    <Directory $WEB_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
""" | sudo tee "$SITE_CONF_DIR/$SITE_NAME.conf" > /dev/null
sudo chown -R $USER:$USER $WEB_ROOT
sudo chmod -R 755 $WEB_ROOT

# Restart Apache
echo "Restarting Apache2..."
systemctl start apache2
sudo a2dissite 000-default.conf
sudo a2ensite "$SITE_NAME.conf"

echo "Provisioning complete. Site is ready!"
```
> 🔁 Replace YOUR_USERNAME/YOUR_REPO_NAME with your actual GitHub repository URL.

---

### 🚀 Step 3: Launch the Environment
Run the following commands in your terminal from the `my-static-site/` directory:
```
vagrant up
```
This will:

1. Download the Ubuntu base image (if not already cached)
2. Create and start the virtual machine
3. Run `provision.sh` to install packages and fetch your website
4. Update your local `/etc/hosts` to map `web-vm.example.local` to `192.168.56.10`

---

## 🌐 Accessing the Website
Once the VM is running and provisioned, open your browser and visit:
```
http://web-vm.example.local
```
You should see the content of your GitHub repository served via Apache.

---

## 🔚 Conclusion
You've now set up a full-featured local development environment that mirrors production behavior using open-source tools. This setup is ideal for:

Front-end developers testing static sites

Quick project demos

Offline development


