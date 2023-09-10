#!/bin/bash

# Change to the directory containing the website files
cd /var/www/www.akashbkochure.com

# Remove existing WordPress installation
sudo rm -rf wordpress
sudo git clone https://github.com/akashbkochure/wordpress.git
cd wordpress

# Configure WordPress
sudo rm -rf wp-config.php
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/example_db/" wp-config.php
sudo sed -i "s/username_here/example_user/" wp-config.php
sudo sed -i "s/password_here/example_pw/" wp-config.php

# Get salt keys and add to wp-config.php
SALT_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sudo sed -i "/AUTH_KEY/s/put your unique phrase here/$SALT_KEYS/" wp-config.php


# Reload Nginx
sudo systemctl reload nginx


# Print a message at the end of the script
echo "Deployment completed."

# Exit the script
exit 0
