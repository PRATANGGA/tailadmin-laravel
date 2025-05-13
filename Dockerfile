FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev libpng-dev libonig-dev libxml2-dev npm \
    && docker-php-ext-install pdo_mysql zip gd mbstring

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working dir
WORKDIR /var/www/tailadmin

# Copy source code
COPY . .

# Copy Apache config
COPY tailadmin.conf /etc/apache2/sites-available/000-default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/tailadmin \
    && chmod -R 775 storage bootstrap/cache

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies & setup app
RUN ./install.sh

EXPOSE 80
CMD ["apache2-foreground"]

