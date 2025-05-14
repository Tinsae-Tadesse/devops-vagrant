#!/bin/bash

# Update the OS
echo "==> Updating OS packages..."
sudo apt-get update -y

# Install Apache2 and Git
echo "==> Installing Apache2 and Git..."
sudo apt-get install git apache2 -y

# Define target directory and GitHub repo
SITE_NAME="web-vm.example.local"
WEB_ROOT="/var/www/$SITE_NAME"
SITE_CONF_DIR="/etc/apache2/sites-available"
REPO_URL="https://github.com/Tinsae-Tadesse/devops-vagrant.git"

# Stop Apache2 Service
echo "==> Stoping Apache2 Service..."
sudo systemctl stop apache2.service

# Cleaning up Files and Directories
echo "==> Cleaning up files and directories..."
sudo rm -fr $SITE_NAME
sudo rm -f "$SITE_CONF_DIR/$SITE_NAME.conf"
sudo rm -fr $WEB_ROOT

# Download Files from Remote Repository
echo "==> Cloning Website..."
git clone $REPO_URL $SITE_NAME
sudo mv $SITE_NAME /var/www/

# Configure Apache2
echo "==> Configuring Apache2..."
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

# Start Apache2 Service
echo "==> Starting Apache2 Service..."
sudo systemctl start apache2.service
sudo a2dissite 000-default.conf
sudo a2ensite "$SITE_NAME.conf"
