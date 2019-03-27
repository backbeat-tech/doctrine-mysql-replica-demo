FROM composer as build

WORKDIR /build
COPY composer.json composer.lock /build/
RUN composer install

FROM php:7.2-alpine

RUN docker-php-ext-install -j$(nproc) pcntl pdo_mysql
WORKDIR /app
COPY --from=build /build/vendor /app/vendor
EXPOSE 8000
COPY . /app
CMD ./bin/console server:run 0.0.0.0:8000
