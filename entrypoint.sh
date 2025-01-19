#!/bin/bash

echo "Starting Laravel setup..."

# Installer les dépendances Composer et NPM
composer install --no-interaction --prefer-dist
npm install
npm run build

# Copier .env si nécessaire
if [ ! -f ".env" ]; then
  echo "Creating .env file from .env.example..."
  cp .env.example .env
fi

# Générer la clé d'application
php artisan key:generate

# Appliquer les migrations
php artisan migrate:fresh --seed

# Fixer les permissions des dossiers
chown -R www-data:www-data /var/www/html
chmod -R 775 storage bootstrap/cache

echo "Laravel setup completed!"

exec "$@"