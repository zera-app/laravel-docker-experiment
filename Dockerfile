FROM ubuntu:24.04 AS base

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    nginx \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev

# Install PHP and extensions
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get install -y \
    php8.3-fpm \
    php8.3-cli \
    php8.3-pgsql \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-bcmath \
    php8.3-gd \
    php8.3-curl

# Ensure PHP-FPM socket directory exists
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Get Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy application
COPY . .

# Install dependencies
RUN composer install
RUN npm install && npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Configure nginx
COPY etc/nginx/default.conf /etc/nginx/sites-available/default

# Start services
CMD service php8.3-fpm start && nginx -g 'daemon off;'
