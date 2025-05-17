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
REPO_URL="https://github.com/Tinsae-Tadesse/devops-vagrant.git"

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
