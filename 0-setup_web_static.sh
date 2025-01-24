#!/bin/bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt update
    sudo apt install -y nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a fake HTML file
echo "<html><head><title>Test</title></head><body><h1>Web Static Deployment</h1></body></html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create or recreate the symbolic link
sudo rm -rf /data/web_static/current
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership to the ubuntu user and group
sudo chown -R hassan_abdisalan:hassan_abdisalan /data/

# Update Nginx configuration
NGINX_CONFIG="/etc/nginx/sites-available/default"
sudo sed -i '/server_name _;/a \
    location /hbnb_static/ {\n        alias /data/web_static/current/;\n    }' "$NGINX_CONFIG"

# Restart Nginx
sudo systemctl restart nginx

exit 0
