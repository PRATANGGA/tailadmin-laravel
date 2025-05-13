# Gunakan image Alpine dengan Apache dan PHP 8
FROM php:8.2-apache-alpine

# Install dependencies system
RUN apk update && apk add --no-cache \
    bash \
    libzip-dev \
    zip \
    unzip \
    curl \
    npm \
    nodejs \
    git \
    oniguruma-dev \
    icu-dev \
    autoconf \
    g++ \
    make \
    linux-headers \
    apache2-utils \
    && docker-php-ext-install pdo pdo_mysql mbstring zip intl

# Aktifkan mod_rewrite untuk Laravel
RUN sed -i '/^#LoadModule rewrite_module/s/^#//' /etc/apache2/httpd.conf && \
    echo "ServerName localhost" >> /etc/apache2/httpd.conf

# Salin konfigurasi Apache yang sudah kamu buat
COPY tailadmin.conf /etc/apache2/conf.d/tailadmin.conf

# Salin source code ke dalam container
COPY . /var/www/html

# Set permission
RUN chown -R apache:apache /var/www/html && chmod -R 775 /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Jalankan setup Laravel
RUN chmod +x install.sh && ./install.sh

# Expose port untuk web server
EXPOSE 80

# Perintah default saat container dijalankan
CMD ["httpd", "-D", "FOREGROUND"]

