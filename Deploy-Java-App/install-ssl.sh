#!/bin/bash
set -e

echo "Installing Certbot for SSL..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

read -p "Enter your domain name (e.g., example.com): " domain

sudo certbot --nginx -d $domain

echo "✅ SSL setup complete for $domain!"