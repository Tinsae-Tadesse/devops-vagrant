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
web.example.local/
├── assets/
│   ├── js/
│   │   ├── contact.js        # Used for semding Ajax requests to contact.php from index.html
├── images/
├── server-scripts/
│   ├── config.php.template   # modified at provisioning time
│   ├── contact.php           # Used for handling contact messages sent by visitors
│   ├── db-connect.php        # Used for estabilishing database connection from php
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
### configuration parameters ###
WEB_HOST = "x.x.x.x"
DB_HOST = "y.y.y.y"
DB_USER = "myuser"
DB_PASS = "mypassword"
DB_NAME = "myapp"
BOX_RAM_MB = "512"
BOX_CPU_COUNT = "1"

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
	  web.vm.network "private_network", ip: WEB_HOST
	    
	  # Provider-specific configurations: such as memory and cpu allocation.
	  web.vm.provider "virtualbox" do |vb|
	     vb.memory = BOX_RAM_MB
	     vb.cpus = BOX_CPU_COUNT
	     vb.name = "web-server"
	  end
	  
	  # Enable provisioning with a Shell script.
	  web.vm.provision "bootstrap-config", type: "shell" do |script|
		  script.path = "./vagrant-scripts/web_provision.sh"
		  script.args = [DB_HOST, DB_USER, DB_PASS, DB_NAME]
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
	  db.vm.network "private_network", ip: DB_HOST
	  
	  # Provider-specific configurations: such as memory and cpu allocation.
	  db.vm.provider "virtualbox" do |vb|
	     vb.memory = BOX_RAM_MB
	     vb.cpus = BOX_CPU_COUNT
	     vb.name = "db-server"
	  end

    # Enable provisioning with a Shell script.
	  db.vm.provision "bootstrap-config", type: "shell" do |script|
		  script.path = "./vagrant-scripts/db_provision.sh"
		  script.args = [DB_HOST]
	  end
  end
end
```
> 🔁 Replace WEB_HOST and DB_HOST with the actual IP addresses assigned for these VMs.

---

### ⚙️ Step 2: Write the Provisioning Scripts
#### web_provision.sh
This script installs Apache2, php, and Git; clones the GitHub repository into the web root, and configures Apache and php.
```
#!/bin/bash

DB_HOST=$1
DB_USER=$2
DB_PASS=$3
DB_NAME=$4

# Configure upstream DNS server
echo "==> Fixing DNS..."
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "==> Finished fixing DNS."

# Update the OS
echo "==> Updating OS packages..."
sudo apt-get update -y
sudo apt-get install build-essential dkms linux-headers-$(uname -r) -y
echo "==> Finished updating OS packages."

# Install Apache2 and Git
echo "==> Installing Apache2, php, and Git..."
sudo apt-get install apache2 php libapache2-mod-php php-mysql git -y
echo "==> Finished installing Apache2, php, and Git."

# Define target directory and GitHub repo
SITE_NAME="web.example.local"
WEB_ROOT="/var/www/$SITE_NAME"
PHP_ROOT="$WEB_ROOT/server-scripts"
SITE_CONF_DIR="/etc/apache2/sites-available"
REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git"

# Stop Apache2 Service
echo "==> Stoping Apache2 Service..."
sudo systemctl stop apache2.service
echo "==> Finished stoping Apache2 service."

# Cleaning up Files and Directories
echo "==> Cleaning up files and directories..."
sudo rm -fr $SITE_NAME
sudo rm -f "$SITE_CONF_DIR/$SITE_NAME.conf"
sudo rm -fr $WEB_ROOT
echo "==> Finished cleaning up files and directories."

# Download Files from Remote Repository
echo "==> Cloning website..."
git clone $REPO_URL $SITE_NAME
sudo mv $SITE_NAME /var/www/
echo "==> Finished cloning wbsite."

# Configure Apache2
echo "==> Configuring Apache2..."
echo """
<VirtualHost 0.0.0.0:80>
    ServerName $SITE_NAME
    DocumentRoot $WEB_ROOT
    <Directory $WEB_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
<VirtualHost [::]:80>
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
echo "==> Finished configuring Apache2."

# Configuring php
echo "==> Configuring PHP..."
echo """
<?php
define('DB_HOST', '${DB_HOST}');
define('DB_USER', '${DB_USER}');
define('DB_PASS', '${DB_PASS}');
define('DB_NAME', '${DB_NAME}');
?>
""" | sudo tee "$PHP_ROOT/config.php.template" > /dev/null
sudo mv "$PHP_ROOT/config.php.template" "$PHP_ROOT/config.php"
echo "==> Finished configuring PHP."

# Start Apache2 Service
echo "==> Starting Apache2 Service..."
sudo systemctl start apache2.service
sudo a2dissite 000-default.conf
sudo a2ensite "$SITE_NAME.conf"
echo "==> Finished starting Apache2 service."
echo "==> Provisioning complete. Site is ready!"
```
> 🔁 Replace YOUR_USERNAME/YOUR_REPO_NAME with your actual GitHub repository URL.

#### db_provision.sh
This script installs MySQL server and configures database schema, database user, user privileges, and database table.
```
#!/bin/bash

DB_VM_IP=$1

# Configure upstream DNS server
echo "==> Fixing DNS..."
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "==> Finished fixing DNS."

# Update the OS
echo "==> Updating OS packages..."
sudo apt-get update -y
sudo apt-get install build-essential dkms linux-headers-$(uname -r) -y
echo "==> Finished updating OS packages."

# Install MySQL
echo "==> Installing MySQL..."
sudo apt-get install mysql-server -y
echo "==> Finished installing MySQL."

# Define environment variables
ROOT_USER="root"
ROOT_PASSWORD="Pass123"
DB_NAME="myapp"
DB_USER="myuser"
DB_USER_PASSWORD="mypassword"

# Configure MySQL
echo "==> Configuring MySQL..."
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_PASSWORD"

mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_VM_IP' IDENTIFIED BY '$DB_USER_PASSWORD';"
mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_VM_IP';"
mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
echo "==> Finished configuring MySQL."

# Configure MySQL
echo "==> Creating database tables..."
mysql -u$ROOT_USER -p$ROOT_PASSWORD $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS contact_messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  subject VARCHAR(100) NOT NULL,
  message TEXT NOT NULL,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF
echo "==> Finished creating database tables."
echo "==> Provisioning complete. MySQL database is ready!"
```

---

### 🚀 Step 3: Launch the Environment
Run the following command in your terminal from the `web.example.local/` directory:
```
vagrant up
```
This will:

1. Download the Ubuntu base image (if not already cached)
2. Create and start the virtual machine
3. Run `web_provision.sh` and `db_provision.sh` to install packages, fetch your website, and make configuration changes
4. Update your local `/etc/hosts` to map `web.example.local` to `x.x.x.x` and `db-vm.local` to `y.y.y.y`

---

## 🌐 Accessing the Website
Once the VMs are running and provisioned, open your browser and visit:
```
http://web.example.local
```
You should see the content of your website inside your GitHub repository served via Apache.

---

## 🔚 Conclusion
You've now set up a full-featured local development environment that mirrors production behavior using open-source tools. This setup is ideal for:

Front-end developers testing static sites

Quick project demos

Offline development


