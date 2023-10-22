#!/bin/bash

# The variables for VM names and IP addresses
MASTER_VM="master"
SLAVE_VM="slave"
MASTER_IP="192.168.33.10"
SLAVE_IP="192.168.33.11"

# Provisioning of the master VM
vagrant up $MASTER_VM

# SSH into the master VM
vagrant ssh $MASTER_VM

# Update package repository
sudo apt update

# Installation of the required packages (LAMP stack)
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql

# Cloning the Laravel application from GitHub
git clone https://github.com/laravel/laravel /var/www/html/laravel

# Configuration of Apache to serve the Laravel application
sudo cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel/storage

# Virtual host configuration for Apache
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/laravel.conf
sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/laravel\/public/' /etc/apache2/sites-available/laravel.conf
sudo a2ensite laravel
sudo a2dissite 000-default
sudo systemctl reload apache2

# Secure MySQL
sudo mysql_secure_installation

# Exit the SSH session
exit