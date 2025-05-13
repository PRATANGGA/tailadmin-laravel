FROM php:8.2-apache

# Install system dependencies
RUN apt update && apt install -y \
    git curl unzip zip \
    libpng-dev libonig-dev libxml2-dev \
    libzip-dev libjpeg-dev libcurl4-openssl-dev \
    npm nodejs

# Enable apache mod_rewrite
RUN a2enmod rewrite

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/tailadmin

# Copy source code
COPY . .

# Copy Apache vhost
COPY tailadmin.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && a2ensite tailadmin.conf

# Set permission
RUN chown -R www-data:www-data /var/www/tailadmin

# Allow install.sh
RUN chmod +x install.sh

EXPOSE 80

CMD ["apache2-foreground"]

