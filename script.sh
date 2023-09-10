#!/bin/bash

# Change to the directory containing the website files
cd /var/www/www.akashbkochure.com

# Pull the latest code changes 
cd wordpress
sudo git pull origin main

# Reload Nginx
sudo systemctl reload nginx

# SSL certificate Test & Renew
# sudo certbot renew --dry-run
# sudo certbot renew

# Print a message at the end of the script
echo "Deployment completed."

# Exit the script
exit 0
