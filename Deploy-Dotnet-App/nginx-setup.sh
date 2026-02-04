#!/bin/bash

# Update package list and install Nginx
sudo apt update
sudo apt install -y nginx

# Remove the default Nginx configuration
sudo rm /etc/nginx/sites-enabled/default

# Create a new Nginx configuration file for the .NET application
cat <<EOL | sudo tee /etc/nginx/sites-available/dotnet_app
server {
    listen 80;
    server_name your_domain_or_ip;

    location / {
        proxy_pass http://localhost:5000; 
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Enable the new configuration
sudo ln -s /etc/nginx/sites-available/dotnet_app /etc/nginx/sites-enabled/

# Test the Nginx configuration for syntax errors
sudo nginx -t

# Restart Nginx to apply the changes
sudo systemctl restart nginx

echo "Nginx setup for .NET application completed."