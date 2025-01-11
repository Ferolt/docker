# Utiliser une image de base PHP avec les extensions nécessaires déjà incluses
FROM php:8.1-fpm-alpine

# Définir le répertoire de travail
WORKDIR /var/www/html

# Installer les dépendances système minimales nécessaires
RUN apk add --no-cache \
    git \
    zip \
    unzip \
    curl \
    npm \
    nodejs \
    libpng-dev \
    libxml2-dev && \
    docker-php-ext-install pdo_mysql mbstring gd

# Copier Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier uniquement les fichiers nécessaires au build initial
COPY composer.json composer.lock ./
COPY package.json package-lock.json ./

# Installer les dépendances Composer et Node.js
RUN composer install --no-dev --optimize-autoloader && \
    npm install && \
    npm run build

# Copier le reste du code de l'application
COPY . .

# Configurer les permissions des dossiers nécessaires
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 storage bootstrap/cache

# Copier et rendre exécutable le script entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
