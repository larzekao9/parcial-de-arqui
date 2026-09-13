FROM php:8.2-cli

RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY ["gym mvc/", "/var/www/html/"]

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html", "index.php"]
