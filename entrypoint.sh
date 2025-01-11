#!/bin/bash

# Copier le bon fichier .env
cp /var/www/html/${LARAVEL_ENV} /var/www/html/.env

# Attendre que MySQL soit prêt
while ! mysqladmin ping -h"$DB_HOST" --silent; do
  echo "Waiting for database connection..."
  sleep 2
done

# Installer les dépendances et configurer Laravel
composer install
npm install && npm run build
php artisan key:generate
php artisan migrate:fresh --seed

# Lancer PHP-FPM
php-fpm
