#!/bin/bash

# Arrêter immédiatement le script en cas d'erreur
set -e

# Attendre que la base de données MySQL soit prête
echo "Waiting for database connection..."
while ! nc -z db 3306; do
  sleep 1
done
echo "Database is ready!"

# Installer les dépendances Composer si nécessaires
if [ ! -d "vendor" ]; then
  echo "Installing Composer dependencies..."
  composer install --no-progress --prefer-dist
fi

# Installer les dépendances Node.js si nécessaires
if [ ! -d "node_modules" ]; then
  echo "Installing Node.js dependencies..."
  npm install --legacy-peer-deps
  npm run build
fi

# Initialiser Laravel
echo "Running Laravel setup..."
php artisan key:generate
php artisan migrate:fresh --seed --force

# Fixer les permissions pour les dossiers de stockage et cache
echo "Setting permissions..."
chmod -R 777 storage bootstrap/cache

# Lancer PHP-FPM
echo "Starting PHP-FPM..."
exec "$@"
