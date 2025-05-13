FROM php:8.2-apache

# Install extensions
RUN apt-get update && apt-get install -y \
    git unzip curl libpng-dev libonig-dev libxml2-dev zip npm \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl gd

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working dir
WORKDIR /var/www/tailadmin

# Copy source code
COPY . .

# Copy Apache config
COPY tailadmin.conf /etc/apache2/sites-available/000-default.conf

# Copy install.sh
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh

# Permissions
RUN chown -R www-data:www-data /var/www/tailadmin \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 80

CMD ["sh", "-c", "/usr/local/bin/install.sh && apache2-foreground"]

