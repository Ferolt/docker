FROM php:8.1-fpm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    nodejs \
    npm

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le dossier de travail
WORKDIR /var/www/html

# Copier le code Laravel
COPY . .

# Installer les dépendances Laravel
RUN composer install && npm install && npm run build

# Automatiser les commandes artisan
RUN php artisan key:generate && php artisan migrate:fresh --seed

# Donner les droits nécessaires
RUN chown -R www-data:www-data /var/www/html

# Exposer le port
EXPOSE 9000

CMD ["php-fpm"]
