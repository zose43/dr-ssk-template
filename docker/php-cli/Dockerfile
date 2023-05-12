FROM php:8.1-cli-alpine

WORKDIR /app

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

# composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# create user
RUN addgroup -g 1000 app && adduser -u 1000 -G app -s /bin/sh -D app

# install dependencies
RUN apk update \
    && apk add openssh-client \
    git

# ssh
RUN mkdir -m 0700 -p /home/app/.ssh/ \
    && ssh-keyscan -p 2222 git.dgt-soft.ru >> /home/app/.ssh/known_hosts \
    && ln -s /run/secrets/host_ssh_key /home/app/.ssh/id_rsa \
    && chmod +x -R /home/app/.ssh/

# remove garbage
RUN rm -rf /tmp/* /var/tmp/* \
      && rm -rf /var/cache/apk/ \
      && rm -rf /usr/share/doc/*

USER app
