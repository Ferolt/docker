#!/bin/bash

# Attendre que la base de données soit prête
echo "Waiting for database connection..."
while ! nc -z db 3306; do
  sleep 1
done
echo "Database is ready!"

# Installer les dépendances et initialiser Laravel
composer install
npm install
npm run build
php artisan key:generate
php artisan migrate:fresh --seed

# Lancer PHP-FPM
exec "$@"
