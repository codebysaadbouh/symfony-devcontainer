# Base image
FROM php:8.3-fpm

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
        git \
        libicu-dev \
        libpq-dev \
        libzip-dev \
        unzip \
        wget \
        zip \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
    bcmath \
    ctype \
    iconv \
    pcre \
    session \
    simplexml \
    tokenizer \
    gd \
    intl \
    pdo_pgsql \
    zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Add opcache.ini to the PHP configuration
ADD opcache.ini $PHP_INI_DIR/conf.d/

# Set the working directory
WORKDIR /www