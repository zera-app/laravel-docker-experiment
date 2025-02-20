#!/bin/bash

# Install PHP dependencies
composer install

# Run migrations
php artisan migrate

# Clear cache
php artisan optimize:clear

# Install Node.js dependencies and build
cd /var/www
npm install
npm run build

# Start PHP-FPM
php-fpm
