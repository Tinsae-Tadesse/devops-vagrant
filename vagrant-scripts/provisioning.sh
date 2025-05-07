#!/bin/bash

# Update the OS
echo "Updating OS packages..."
sudo apt-get update -y

# Install Git
echo "Installing git..."
sudo apt-get install git -y

# Install Apache
echo "Installing apache2..."
sudo apt-get install apache2 -y
