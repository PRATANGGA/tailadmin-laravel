FROM ubuntu:22.04

RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    apache2 \
    php \
    php-cli \
    php-mbstring \
    php-xml \
    php-curl \
    php-mysql \
    php-gd \
    unzip \
    nano \
    curl \
    git \
    npm

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /var/www/tailadmin
WORKDIR /var/www/tailadmin

COPY . .

COPY sosmed.conf /etc/apache2/sites-available/
RUN a2dissite 000-default.conf && a2ensite sosmed.conf && a2enmod rewrite

RUN mkdir -p bootstrap/cache storage/framework/{sessions,views,cache} storage/logs && \
    chown -R www-data:www-data . && chmod -R 775 bootstrap storage

RUN chmod +x install.sh && ./install.sh

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]

