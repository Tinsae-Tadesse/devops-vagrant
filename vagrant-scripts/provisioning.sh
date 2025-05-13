#!/bin/bash

# Update the OS
echo "==> Updating OS packages..."
sudo apt-get update -y

# Install Git
echo "==> Installing Git..."
sudo apt-get install git -y

# Install Apache
echo "==> Installing Apache2..."
sudo apt-get install apache2 -y

# Stop Apache2 Service
echo "==> Stoping Apache2 Service..."
sudo systemctl stop apache2.service

# Cleaning up Files and Directories
echo "==> Cleaning up files and directories..."
sudo rm -fr ./devops-vagrant
sudo rm -fr ./web-vm.example.local
sudo rm -f /etc/apache2/sites-available/web-vm.example.local.conf
sudo rm -fr /var/www/web-vm.example.local

# Download Files from Remote Repository
echo "==> Cloning Website..."
git clone https://github.com/Tinsae-Tadesse/devops-vagrant.git
sudo mv ./devops-vagrant web-vm.example.local
sudo mv ./web-vm.example.local /var/www/

# Configure Apache2
sudo echo "==> Configuring Apache2..."
sudo echo """
<VirtualHost *:80>
    ServerName web-vm.example.local
    DocumentRoot /var/www/web-vm.example.local
    <Directory /var/www/web-vm.example.local>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
""" > /etc/apache2/sites-available/web-vm.example.local.conf
sudo chown -R $USER:$USER /var/www/web-vm.example.local
sudo chmod -R 755 /var/www/web-vm.example.local

# Start Apache2 Service
echo "==> Starting Apache2 Service..."
sudo systemctl start apache2.service
sudo a2dissite 000-default.conf
sudo a2ensite web-vm.example.local
