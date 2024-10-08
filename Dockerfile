# Set the base image
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    git \
    unzip

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql



# Set working directory
WORKDIR /var/www/html

COPY ./src /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Composer dependencies
RUN composer install


# Install Node.js and NPM
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Laravel Breeze and its dependencies
RUN composer require laravel/breeze --dev \
    && php artisan breeze:install

# Install Node.js dependencies and compile assets
RUN npm install \
    && npm run dev

# Copy application files

# Expose port
EXPOSE 8000

# Start PHP-FPM server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
#This CMD part caused me so much problem. Keep in mind for the next time.
