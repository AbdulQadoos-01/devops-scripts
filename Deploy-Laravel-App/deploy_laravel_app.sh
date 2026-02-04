#!/bin/bash

# Laravel Application Deployment Script for Ubuntu (Nginx, MySQL, PHP-FPM)

set -e

function clone_repo() {
    echo "Cloning the repository..."
    read -p "Enter the GitHub URL: " github_url

    repo_name=$(basename -s .git "$github_url")
    TARGET_DIR="/var/www/$repo_name"

    if [ -d "$TARGET_DIR" ]; then
        echo "⚠️  Directory $TARGET_DIR already exists. Pulling latest changes instead."
        cd "$TARGET_DIR"
        git pull origin $(git symbolic-ref --short HEAD)
    else
        if git clone "$github_url" "$TARGET_DIR"; then
            echo "✅ Successfully cloned $repo_name"
            cd "$TARGET_DIR" || { echo "Failed to cd into $TARGET_DIR"; exit 1; }
        else
            echo "❌ Git clone failed."
            exit 1
        fi
    fi
}

function install_dependencies() {
    echo "Installing required dependencies..."

    # Update system
    sudo apt-get update
    sudo apt-get upgrade -y

    # Check and install PHP
    if ! command -v php &> /dev/null; then
        echo "Installing PHP and extensions..."
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository ppa:ondrej/php -y
        sudo apt-get update
        sudo apt-get install -y php8.2-fpm php8.2-common php8.2-mysql php8.2-xml \
        php8.2-curl php8.2-gd php8.2-imagick php8.2-cli php8.2-dev \
        php8.2-imap php8.2-mbstring php8.2-opcache php8.2-soap \
        php8.2-zip php8.2-bcmath
    else
        echo "✅ PHP already installed: $(php -v | head -n 1)"
    fi

    # Check and install Nginx
    if ! command -v nginx &> /dev/null; then
        echo "Installing Nginx..."
        sudo apt-get install -y nginx
    else
        echo "✅ Nginx already installed: $(nginx -v 2>&1)"
    fi

    # Check and install MySQL
    if ! command -v mysql &> /dev/null; then
        echo "Installing MySQL..."
        sudo apt-get install -y mysql-server
        echo "⚠️  Please run 'sudo mysql_secure_installation' after deployment to secure MySQL"
    else
        echo "✅ MySQL already installed: $(mysql --version)"
    fi

    # Check and install Composer
    if ! command -v composer &> /dev/null; then
        echo "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x /usr/local/bin/composer
    else
        echo "✅ Composer already installed: $(composer --version)"
    fi

    # Install Node.js for frontend assets (if needed)
    if ! command -v node &> /dev/null; then
        echo "Installing Node.js for frontend builds..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "✅ Node.js already installed: $(node -v)"
    fi
}

function setup_application() {
    echo "Setting up Laravel application..."

    # Copy environment file
    if [ ! -f ".env" ]; then
        cp .env.example .env
        echo "✅ Created .env file from .env.example"
    else
        echo "✅ .env file already exists"
    fi

    # Install PHP dependencies
    composer install --no-dev --optimize-autoloader

    # Generate application key
    if ! grep -q "APP_KEY=base64" .env; then
        php artisan key:generate
        echo "✅ Generated application key"
    else
        echo "✅ Application key already exists"
    fi

    # Set permissions
    sudo chown -R www-data:www-data storage bootstrap/cache
    sudo chmod -R 775 storage bootstrap/cache
    echo "✅ Set correct permissions"

    # Install frontend dependencies and build (if needed)
    if [ -f "package.json" ]; then
        npm install
        npm run build
        echo "✅ Built frontend assets"
    fi
}

function setup_database() {
    echo "Setting up database..."

    read -p "Do you want to create a new MySQL database? (y/n): " create_db
    if [[ $create_db == "y" || $create_db == "Y" ]]; then
        read -p "Enter MySQL root password: " -s root_password
        echo
        read -p "Enter database name: " db_name
        read -p "Enter database user: " db_user
        read -p "Enter database password: " -s db_password
        echo

        # Create database and user
        sudo mysql -u root -p"$root_password" <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

        echo "✅ Database and user created"

        # Update .env file with database credentials
        sed -i "s/DB_DATABASE=.*/DB_DATABASE=$db_name/" .env
        sed -i "s/DB_USERNAME=.*/DB_USERNAME=$db_user/" .env
        sed -i "s/DB_PASSWORD=.*/DB_PASSWORD='$db_password'/" .env
        echo "✅ Updated .env with database credentials"
    fi

    # Run migrations
    read -p "Run database migrations? (y/n): " run_migrations
    if [[ $run_migrations == "y" || $run_migrations == "Y" ]]; then
        php artisan migrate --force
        echo "✅ Database migrations completed"
    fi
}

function final_steps() {
    echo "Performing final optimizations..."

    # Optimize Laravel
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache

    # Set up scheduler cron job
    (crontab -l 2>/dev/null; echo "* * * * * cd /var/www/$(basename $PWD) && php artisan schedule:run >> /dev/null 2>&1") | crontab -

    echo "✅ Application optimized and scheduler configured"
}

# Main execution
echo "Laravel Deployment Started..."

clone_repo
install_dependencies
setup_application
setup_database
final_steps

echo "✅ Laravel Deployment Completed Successfully!"
echo "🌐 Your application should now be accessible at your server's IP address or domain"
echo "📝 Don't forget to:"
echo "   - Run 'sudo mysql_secure_installation' to secure MySQL"
echo "   - Update your .env file with any additional configuration"
echo "   - Set up any queue workers if your application uses them"