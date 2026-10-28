# Shoal container deployment for Stargate Wars
# Apache serves the existing PHP application on port 80.
FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libpng-dev \
       libjpeg62-turbo-dev \
       libfreetype6-dev \
       libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j1 mysqli pdo_mysql gd mbstring zip \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

ENV APACHE_DOCUMENT_ROOT=/var/www/html
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

# Align Apache virtual hosts and security configuration with the document root.
RUN sed -ri 's!/var/www/html!$APACHE_DOCUMENT_ROOT!g' /etc/apache2/sites-available/*.conf \
    && sed -ri 's!/var/www/!$APACHE_DOCUMENT_ROOT!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY --chown=www-data:www-data . /var/www/html/

# Health endpoint confirms Apache/PHP is responding; it does not query MySQL.
RUN printf '%s\\n' '<?php http_response_code(200); header("Content-Type: text/plain"); echo "ok";' \
      > /var/www/html/healthz.php \
    && chown www-data:www-data /var/www/html/healthz.php

EXPOSE 80
