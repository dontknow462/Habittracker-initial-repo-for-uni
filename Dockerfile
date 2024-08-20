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

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application files
COPY ./src /var/www/html

# Expose port
EXPOSE 8000

# Start PHP-FPM server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
#This CMD part caused me so much problem. Keep in mind for the next time.
