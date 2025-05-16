#!/bin/bash

DB_VM_IP=$1

# Configure upstream DNS server
echo "==> Fixing DNS..."
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

# Update the OS
echo "==> Updating OS packages..."
sudo apt-get update -y
sudo apt-get install build-essential dkms linux-headers-$(uname -r) -y

# Install MySQL
echo "==> Installing MySQL..."
sudo apt-get install mysql-server -y

# Define environment variables
ROOT_USER="root"
ROOT_PASSWORD="root"
DB_NAME="myapp"
DB_USER="myuser"
DB_USER_PASSWORD="mypassword"

# Configure MySQL
echo "==> Configuring MySQL..."
debconf-set-selections <<< "mysql-server mysql-server/root_password password $ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ROOT_PASSWORD"

mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'$WEB_VM_IP' IDENTIFIED BY '$DB_USER_PASSWORD';"
mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$WEB_VM_IP';"
mysql -u$ROOT_USER -p$ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Configure MySQL
echo "==> Creating database table..."
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
