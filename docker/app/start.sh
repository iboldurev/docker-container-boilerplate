#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}

if [ "$env" != "local" ]; then

    echo "Caching configuration..."

    (cd /var/www/html && php artisan config:cache && php artisan route:cache && php artisan view:cache)

fi

if [[ "$role" = "app" ]]; then

    exec /init

elif [[ "$role" = "queue" ]]; then

    echo "Running the queue..."

    php /var/www/artisan queue:work --verbose --tries=3 --daemon

elif [[ "$role" = "scheduler" ]]; then

    while [[ true ]]
    do
      php /var/www/artisan schedule:run --verbose --version --no-interaction &
      sleep 60
    done

else
    echo "Could not match the container role \"$role\""
    exit 1
fi
