#!/bin/bash

echo -e "\n\nUpdating and upgrading\n"
sudo apt update && sudo apt upgrade -y < /dev/null
sudo apt-get install apache2 -y < /dev/null
sudo apt-get install mysql-server -y < /dev/null
echo -e "\n\nUpdate and upgrade successful\n"

echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt update -y < /dev/null
sudo apt install -y wget git apache2 curl < /dev/null
echo -e "\n\nUpdate done!\n"

echo -e "\n\nInstalling Apache\n"
sudo apt install apache2 -y < /dev/null
echo -e "\n\nApache installed\n"

echo -e "\n\nInstalling PHP\n"
sudo add-apt-repository ppa:ondrej/php -y < /dev/null
sudo apt update -y < /dev/null
sudo apt-get install libapache2-mod-php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.2/apache2/php.ini
sudo systemctl restart apache2
echo -e "\n\nPHP successfully installed\n"

echo -e "\n\nInstalling Composer\n"
sudo apt-get update -y < /dev/null
sudo apt install curl -y < /dev/null
sudo apt install -y git < /dev/null
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
export COMPOSER_ALLOW_SUPERUSER=1

composer --version < /dev/null
echo -e "\n\nComposer successfully installed\n"

echo -e "\n\nApache Configuration\n"
sudo tee -a  /etc/apache2/sites-available/laravel.conf <<EOF
<VirtualHost *:80>
    ServerAdmin 4tunechika@gmail.com
    ServerName 192.168.27.88
    DocumentRoot /var/www/html/laravel/public
    <Directory /var/www/html/laravel/public>
        Options Indexes Multiviews FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2enmod rewrite
sudo a2ensite laravel.conf
sudo systemctl restart apache2
echo -e "\n\nApache configuration complete\n"

echo -e "\n\nInstalling Laravel from GitHub\n"
rm -rf /var/www/html/laravel
mkdir -p /var/www/html/laravel
git clone https://github.com/laravel/laravel /var/www/html/laravel
cd /var/www/html/laravel && composer install --no-dev < /dev/null
sudo chown -R www-data:www-data /var/www/html/laravel
echo -e "\n\nLaravel successfully installed from GitHub repo\n"

echo -e "\n\nSetting file permissions\n"
sudo chmod -R 775 /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
echo -e "\n\nFile permissions set\n"

echo -e "\n\nCreating a .env file in Laravel\n"
cd /var/www/html/laravel && cp .env.example .env
cd /var/www/html/laravel && php artisan key:generate
echo -e "\n\nThe .env file successfully created\n"

echo "Creating MySQL user and database"
DB_NAME="Arua"
DB_USER="Arua"
DB_PASS="Arua527"

mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL credentials"
echo "Username: $DB_USER"
echo "Database: $DB_NAME"
echo "Password: $DB_PASS"

echo "Updating .env file with MySQL credentials"
sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB_NAME/" /var/www/html/laravel/.env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=$DB_USER/" /var/www/html/laravel/.env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASS/" /var/www/html/laravel/.env
echo -e "\n\n.env file updated with MySQL credentials\n"

echo -e "\n\nRunning Laravel migrations\n"
cd /var/www/html/laravel && php artisan migrate
echo -e "\n\nMigrations\n"
