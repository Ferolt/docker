#!/bin/bash

echo "Starting Laravel setup..."

# Vérifier et installer les dépendances si nécessaires
if [ ! -d "vendor" ]; then
  echo "Installing Composer dependencies..."
  composer install --no-dev --optimize-autoloader
fi

if [ ! -d "node_modules" ]; then
  echo "Installing Node.js dependencies..."
  npm install
  npm run build
fi

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
