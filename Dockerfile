FROM php:8.1-fpm

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    nodejs \
    npm \
    mariadb-client

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le dossier de travail
WORKDIR /var/www/html

# Copier les fichiers Laravel
COPY . .

# Ajouter le script wait-for-it
COPY wait-for-it.sh /usr/bin/wait-for-it
RUN chmod +x /usr/bin/wait-for-it

# Ajouter le script init
COPY init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

# Donner les permissions nécessaires
RUN chmod -R 777 storage bootstrap/cache

# Exposer le port
EXPOSE 9000

CMD ["/usr/bin/init.sh"]
