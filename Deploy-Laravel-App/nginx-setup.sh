#!/bin/bash

# NGINX configuration for Laravel application

set -e

function install_nginx() {
    echo "Installing NGINX..."
    sudo apt-get update
    sudo apt install -y nginx
    sudo systemctl enable nginx
    echo "✅ NGINX installed and enabled"
}

function configure_nginx() {
    read -p "Enter your domain or IP: " server_name
    read -p "Enter config name (e.g., my-laravel-app): " nginx_conf
    
    # Get the project directory path
    read -p "Enter full path to Laravel project (e.g., /var/www/my-app): " project_path
    
    # Verify the path exists
    if [ ! -d "$project_path" ]; then
        echo "❌ Error: Directory $project_path does not exist!"
        exit 1
    fi

    # Verify the public directory exists
    if [ ! -d "$project_path/public" ]; then
        echo "❌ Error: Public directory not found at $project_path/public!"
        echo "Make sure this is a Laravel project directory"
        exit 1
    fi

    config_path="/etc/nginx/sites-available/$nginx_conf"

    echo "Writing NGINX config for Laravel to $config_path"

    sudo tee "$config_path" > /dev/null <<EOF
server {
    listen 80;
    server_name $server_name;
    root $project_path/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php index.html index.htm;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php\$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

    # Enable the site
    sudo ln -sf "$config_path" "/etc/nginx/sites-enabled/"
    
    # Remove default nginx config if it exists
    if [ -f "/etc/nginx/sites-enabled/default" ]; then
        sudo rm "/etc/nginx/sites-enabled/default"
    fi

    echo "Testing NGINX configuration..."
    sudo nginx -t

    echo "Restarting NGINX..."
    sudo systemctl restart nginx

    echo "✅ NGINX is now configured for Laravel at: $project_path"
    echo "🌐 Your Laravel app should be accessible at: http://$server_name"
}

function check_php_fpm() {
    echo "Checking PHP-FPM status..."
    
    # Check if PHP-FPM is installed and running
    if ! systemctl is-active --quiet php8.2-fpm; then
        echo "⚠️  PHP8.2-FPM is not running. Installing and starting it..."
        sudo apt install -y php8.2-fpm
        sudo systemctl enable php8.2-fpm
        sudo systemctl start php8.2-fpm
    fi
    
    sudo systemctl status php8.2-fpm --no-pager
    echo "✅ PHP-FPM is ready"
}

function set_permissions() {
    echo "Setting correct permissions for Laravel..."
    
    if [ -d "$project_path" ]; then
        sudo chown -R www-data:www-data "$project_path/storage"
        sudo chown -R www-data:www-data "$project_path/bootstrap/cache"
        sudo chmod -R 775 "$project_path/storage"
        sudo chmod -R 775 "$project_path/bootstrap/cache"
        echo "✅ Permissions set for storage and bootstrap/cache directories"
    else
        echo "⚠️  Project path not found, skipping permission setup"
    fi
}

# Main execution
echo "Laravel NGINX Configuration Started..."

install_nginx
check_php_fpm
configure_nginx
set_permissions

echo "✅ Laravel NGINX configuration completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Make sure your .env file is properly configured"
echo "2. Run: php artisan optimize"
echo "3. Run: php artisan storage:link (if using file storage)"
echo "4. Set up SSL with Certbot when ready: sudo certbot --nginx"