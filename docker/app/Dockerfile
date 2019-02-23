FROM ubuntu:18.04

LABEL maintainer="Ivan Boldyrev <iboldurev@gmail.com>"

ENV TZ UTC
ENV PHP_VERSION 7.2
ENV COMPOSER_VERSION 1.7.2
ENV S6_OVERLAY_VERSION 1.21.7.0

RUN export LC_ALL=C.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it.sh
RUN chmod +x /bin/wait-for-it.sh

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# PHP
RUN apt-get update && \
    apt-get install -y \
    nginx wget sudo autoconf autogen language-pack-en-base wget zip unzip curl rsync ssh openssh-client git \
    build-essential apt-utils software-properties-common nasm libjpeg-dev libpng-dev libpng16-16 \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-sqlite \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-memcached \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-apc \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-apcu && \
    apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/php && chmod -R 755 /run/php

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer && composer self-update --preview
RUN command -v composer

# PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit
RUN command -v phpunit

# Security Checker
RUN wget http://get.sensiolabs.org/security-checker.phar
RUN chmod +x security-checker.phar
RUN mv security-checker.phar /usr/local/bin/security-checker
RUN command -v security-checker

COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/services.d/nginx/start-nginx.sh /etc/services.d/nginx/run

RUN chmod 755 /etc/services.d/nginx/run

COPY etc/php/fpm/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini
COPY etc/php/fpm/php-fpm.conf /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
COPY etc/php/fpm/pool.d/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY etc/services.d/php_fpm/start-fpm.sh /etc/services.d/php_fpm/run

RUN chmod 755 /etc/services.d/php_fpm/run

COPY start.sh /usr/local/bin/start

RUN chmod 755 /usr/local/bin/start

RUN chown -R www-data:www-data /var/www

# Display versions installed
RUN php -v
RUN php -m
RUN composer --version
RUN phpunit --version
RUN security-checker --version

WORKDIR /var/www

CMD ["/usr/local/bin/start"]
