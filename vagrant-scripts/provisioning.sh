#!/bin/bash

# Update the OS
echo "---------> Updating OS packages..."
sudo apt-get update -y

# Install Git
echo "---------> Installing Git..."
sudo apt-get install git -y

# Install Apache
echo "---------> Installing Apache2..."
sudo apt-get install apache2 -y

# Stop Apache2 Service
echo "---------> Stoping Apache2 Service..."
sudo systemctl stop apache2.service

# Download Files from Remote Repository
echo "---------> Cloning Website..."
git clone https://github.com/Tinsae-Tadesse/devops-vagrant.git
sudo mv ./devops-vagrant my-site.com
sudo mv ./my-site.com /var/www/

# Configure Apache2
sudo echo "---------> Configuring Apache2..."
sudo echo """
<VirtualHost *:80>
    ServerName my-site.com
    DocumentRoot /var/www/my-site.com
    <Directory /var/www/my-site.com>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
""" > /etc/apache2/sites-available/my-site.com.conf
sudo chown -R $USER:$USER /var/www/my-site.com
sudo chmod -R 755 /var/www/my-site.com

# Start Apache2 Service
echo "---------> Starting Apache2 Service..."
sudo systemctl start apache2.service
sudo a2dissite 000-default.conf
sudo a2ensite my-site.com.conf
