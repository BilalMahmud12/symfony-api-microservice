# Base image
FROM php:8.2-apache

# Install necessary dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libicu-dev \
    libpq-dev \
    libzip-dev \
    mariadb-client \
    libmariadb-dev \
    && docker-php-ext-install pdo pdo_mysql intl opcache

# Enable Apache modules
RUN a2enmod rewrite

# Set up Apache configuration to allow overrides and point DocumentRoot to /public
RUN echo "<VirtualHost *:80>" > /etc/apache2/sites-available/000-default.conf && \
    echo "    DocumentRoot /var/www/html/public" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    <Directory /var/www/html/public>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        AllowOverride All" >> /etc/apache2/sites-available/000-default.conf && \
    echo "        Require all granted" >> /etc/apache2/sites-available/000-default.conf && \
    echo "    </Directory>" >> /etc/apache2/sites-available/000-default.conf && \
    echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf

# Set ServerName to avoid warnings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Set the working directory
WORKDIR /var/www/html

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Copy the Symfony application code to the container
COPY symfony_app/ /var/www/html

# Install PHP dependencies using Composer
RUN composer install

# Set correct permissions for cache and logs
RUN chown -R www-data:www-data /var/www/html/var/cache /var/www/html/var/log

# Expose port 80
EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]
