#!/bin/bash

# Attendre que MySQL soit prêt
echo "Waiting for MySQL to be ready..."
/usr/bin/wait-for-it db:3306 --timeout=30 -- echo "MySQL is ready!"

# Exécuter les commandes Laravel
echo "Running Laravel setup..."
composer install
npm install
npm run build
php artisan key:generate
php artisan migrate:fresh --seed

# Lancer PHP-FPM
php-fpm
