#!/bin/bash

# Define variables
WEBSITE_DIR="/var/www/www.akashbkochure.com"
GIT_REPO="https://github.com/akashbkochure/wordpress.git"

# Move to the website directory
cd "$WEBSITE_DIR" || exit 1

# Fetch the latest changes from the Git repository
git fetch origin

# Get the latest commit hash of the repository
LATEST_COMMIT=$(git rev-parse origin/main)

# Get the current commit hash of the local repository
CURRENT_COMMIT=$(git rev-parse HEAD)

# Compare the current commit with the latest commit
if [ "$LATEST_COMMIT" = "$CURRENT_COMMIT" ]; then
    echo "No changes detected. Deployment not needed."
    exit 0
fi

# Backup existing WordPress installation (optional)
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_DIR="$WEBSITE_DIR/backup_$TIMESTAMP"
mkdir "$BACKUP_DIR"
cp -r wordpress "$BACKUP_DIR"

# Update the website files
git reset --hard origin/main

# Stop and start the Nginx service
sudo systemctl stop nginx
sudo systemctl start nginx

echo "Deployment completed."

exit 0
