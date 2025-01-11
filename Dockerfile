FROM php:8.1-fpm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    npm

# Installer les extensions PHP
RUN docker-php-ext-install pdo_mysql mbstring gd

# Copier le script d'entrée
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Définir le répertoire de travail
WORKDIR /var/www/html

# Exposer le port
EXPOSE 9000

# Définir le script entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
