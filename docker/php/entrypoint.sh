#!/bin/bash

set -e

# Ensure the app key exists and copy if missing
if [ ! -f /var/www/html/.env ]; then
    cp /var/www/html/.env.example /var/www/html/.env
fi

# Run Composer install
composer install

# Run database migrations for development and testing
php bin/console doctrine:database:create --if-not-exists
php bin/console doctrine:migrations:migrate --no-interaction

# Call the original entrypoint command
php-fpm &
exec "$@"
