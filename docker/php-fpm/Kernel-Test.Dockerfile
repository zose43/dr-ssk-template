FROM php:8.1-fpm-alpine

WORKDIR /app

COPY composer.json ./

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

# composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN apk update \
    && apk add openssh-client \
    icu-dev \
    git

#ssh
RUN mkdir -m 0700 -p ~/.ssh \
    && ssh-keyscan -p 2222 git.dgt-soft.ru >> ~/.ssh/known_hosts

#composer install
RUN --mount=type=ssh composer install --ignore-platform-reqs --no-plugins --no-scripts

# intl --> for operations with locals
RUN apk --no-cache update \
    && docker-php-ext-configure intl && docker-php-ext-install intl

# remove garbage
RUN rm -rf /tmp/* /var/tmp/* \
      && rm -rf /var/cache/apk/ \
      && rm -rf /usr/share/doc/*

COPY . .

CMD ["vendor/bin/phpunit", "tests/functional"]
