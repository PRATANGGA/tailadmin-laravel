FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip zip curl git nano libzip-dev libpng-dev libonig-dev \
    libxml2-dev npm nodejs \
    && docker-php-ext-install pdo pdo_mysql zip mbstring gd

# Enable mod_rewrite
RUN a2enmod rewrite

# Salin konfigurasi Apache
COPY tailadmin.conf /etc/apache2/sites-available/000-default.conf

# Copy project
COPY . /var/www/html

# Set permission
RUN chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Jalankan install.sh
RUN chmod +x install.sh && ./install.sh

EXPOSE 80
CMD ["apache2-foreground"]

