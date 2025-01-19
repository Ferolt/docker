FROM php:8.1-fpm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    curl \
    nodejs \
    npm

# Installer les extensions PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring zip pdo pdo_mysql


# Copier Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Copier le contenu de votre projet dans l'image Docker
COPY . /var/www/html

# Créer les répertoires nécessaires si ils n'existent pas
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache

# Donner les permissions appropriées
RUN chown -R www-data:www-data /var/www/html/  
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
# Copier le script entrypoint.sh dans le conteneur
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir le script entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Démarrer le serveur PHP-FPM
CMD ["php-fpm"]
