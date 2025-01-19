#!/bin/bash
set -e
echo "Clearing laravel cache..."
php artisan route:clear
php artisan config:clear
php artisan cache:clear
php artisan optimize:clear

echo "Starting setup for $PHP_HOTE..."

if [ -z "$PHP_HOTE" ]; then
    echo "Error: PHP_HOTE is not defined. Set it to 'php1' or 'php2'."
    exit 1
fi

if [ "$PHP_HOTE" = "php1" ]; then
    # Configuration spécifique pour php1
    composer install
    php artisan key:generate
    php artisan migrate --force
    touch /var/www/html/composer_installed.lock
elif [ "$PHP_HOTE" = "php2" ]; then
    # Configuration spécifique pour php2
    while [ ! -f /var/www/html/composer_installed.lock ]; do
        echo "Waiting for PHP1 to finish setup..."
        sleep 5
    done

    php artisan key:generate
    php artisan migrate --force
fi

exec php-fpm