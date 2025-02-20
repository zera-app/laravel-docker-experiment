FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Create scripts directory with proper permissions
RUN mkdir -p /var/www/docker/scripts && \
    chown -R www:www /var/www/docker/scripts && \
    chmod -R 755 /var/www/docker/scripts

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Make startup script executable
COPY --chown=www:www docker/scripts/startup.sh /var/www/docker/scripts/
RUN chmod +x /var/www/docker/scripts/startup.sh

# Change current user to www
USER www
