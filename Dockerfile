FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y apache2 php php-xml php-curl php-mysql php-gd npm unzip curl php-cli

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php

# Setup direktori aplikasi
RUN mkdir -p /var/www/tailadmin
WORKDIR /var/www/tailadmin

# Copy project ke container
COPY . /var/www/tailadmin

# Salin konfigurasi Apache
COPY tailadmin.conf /etc/apache2/sites-available/

# Enable virtual host dan modul PHP
RUN a2dissite 000-default.conf && \
    a2ensite tailadmin.conf && \
    a2enmod rewrite

# Install dependency Laravel
RUN composer install --no-interaction --prefer-dist --optimize-autoloader && \
    npm install && npm run build || true

# Laravel permission dan key
RUN chown -R www-data:www-data /var/www/tailadmin && \
    chmod -R 755 /var/www/tailadmin && \
    php artisan key:generate

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]

