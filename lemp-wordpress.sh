#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y
sudo systemctl enable nginx

# Install PHP and required extensions
sudo apt install php7.4-fpm php7.4-mysql php7.4-cli php7.4-common php7.4-readline -y

# Install MariaDB
sudo apt install mariadb-server -y

# Secure MariaDB installation
sudo mysql_secure_installation

# Download and set up WordPress
sudo mkdir -p /var/www/www.akashbkochure.com
cd /var/www/www.akashbkochure.com
sudo rm -rf wordpress
sudo apt install git -y
sudo git clone https://github.com/akashbkochure/wordpress.git
cd wordpress

# Create WordPress database
sudo mysql -e "CREATE DATABASE example_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "CREATE USER 'example_user'@'localhost' IDENTIFIED BY 'example_pw';"
sudo mysql -e "GRANT ALL PRIVILEGES ON example_db.* TO 'example_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Configure WordPress
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/example_db/" wp-config.php
sudo sed -i "s/username_here/example_user/" wp-config.php
sudo sed -i "s/password_here/example_pw/" wp-config.php

# Get salt keys and add to wp-config.php
SALT_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sudo sed -i "/AUTH_KEY/s/put your unique phrase here/$SALT_KEYS/" wp-config.php

# Create Nginx configuration
sudo tee /etc/nginx/sites-available/www.akashbkochure.com > /dev/null <<EOT
server {
    listen 80;
    server_name www.akashbkochure.com;

    root /var/www/www.akashbkochure.com/wordpress;
    index index.php index.html index.htm;

    location ^~ /.well-known/acme-challenge/ {
        allow all;
        root /var/www/www.akashbkochure.com/wordpress;
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOT

# Enable the Nginx configuration
sudo ln -s /etc/nginx/sites-available/www.akashbkochure.com /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Test Nginx configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx



# Install Certbot and obtain SSL certificate
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-get update
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx

echo "Setup completed! Access your WordPress site using the Secure Site encryption Domain-Name"
