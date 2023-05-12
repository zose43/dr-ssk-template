FROM php:8.1-fpm-alpine

WORKDIR /app

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

#alias
RUN echo 'alias yii="php yii"' >> ~/.profile
RUN echo 'alias selenium="./vendor/digitalreputationcorp/search_systems/src/webdriver/chromedriver112 --port=4444"' >> ~/.profile

# xdebug install
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --update linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del -f .build-deps

# install dependencies
# jpeg-dev libpng-dev for phpspreadsheet
RUN apk update \
    && apk add libzip-dev \
    icu-dev

# install php dependencies
# for pdo_pgsql --> postgresql-dev
# docker-php-ext-configure gd --with-jpeg && docker-php-ext-install gd --> phpspreadsheet
#add --no-cache postgresql-dev libpq && docker-php-ext-install pdo_pgsql pgsql && apk del postgresql-dev --> postgres + pdo
RUN apk --no-cache update \
    && apk add --no-cache postgresql-dev libpq \
    && docker-php-ext-install pdo_pgsql pgsql \
    && docker-php-ext-configure zip && docker-php-ext-install zip \
    && docker-php-ext-configure intl && docker-php-ext-install intl \
    && apk del postgresql-dev

# remove garbage
RUN rm -rf /tmp/* /var/tmp/* \
      && rm -rf /var/cache/apk/ \
      && rm -rf /usr/share/doc/*
