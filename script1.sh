#!/bin/bash

# Navigate to the WordPress directory
cd /var/www/www.akashbkochure.com/wordpress

# Update the WordPress codebase
sudo git pull origin main

# Update the wp-config.php file
sudo sed -i "s/database_name_here/example_db/" wp-config.php
sudo sed -i "s/username_here/example_user/" wp-config.php
sudo sed -i "s/password_here/example_pw/" wp-config.php

# Get salt keys and update wp-config.php
SALT_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sudo sed -i "/AUTH_KEY/s/put your unique phrase here/$SALT_KEYS/" wp-config.php

# Reload Nginx to apply changes
sudo systemctl reload nginx

echo "WordPress codebase and configuration updated!"
