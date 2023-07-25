FROM php:8.0-fpm

#alias
RUN echo 'alias yii="php yii"' >> /var/www/.bashrc

# wv --> ms doc,docx
# libkrb5-dev && libc-client-dev --> required for imap extension
# poppler-utils --> pdf
# libzip-dev --> xls,xlsx and zip
# procps --> ps, kill commands for monitorng processes
# libgl1 --> for python computer vision (captcha)
# wget --> for download
RUN apt-get update && apt-get install -y libgl1 \
	&& docker-php-ext-install pdo pdo_pgsql \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug

# Install python and pip, install requirements
# Pillow and opencv-python --> for computer vision(captcha)
RUN apt-get update && apt-get install -y python3 python3-pip \
    && pip3 install --no-cache opencv-python Pillow

#ssh
#RUN mkdir -m 0700 -p /var/www/.ssh \
#    && ssh-keyscan -p 2222 git.dgt-soft.ru >> /var/www/.ssh/known_hosts \
#    && ln -s /run/secrets/host_ssh_key /var/www/.ssh/id_rsa \
#    && chmod +x -R /var/www/.ssh/

#user
RUN usermod -u 1000 -d /var/www/ www-data \
  && groupmod -g 1000 www-data \
  && chown -R www-data:www-data /var/www

# intl --> operations with locale or dependency from locale
#RUN docker-php-ext-configure intl && docker-php-ext-install intl

# sockets use for chrome-binary (docker-php-ext-install sockets)
RUN docker-php-ext-install sockets
# chrome binary for screenshots, no selenium
#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
#	&& sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
#	&& apt-get update \
#	&& apt-get -y install google-chrome-stable \
#		--no-install-recommends \
#	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* /etc/cron.*/*

# remove garbage
RUN rm -rf /tmp/* /var/tmp/* \
      && rm -rf /var/cache/apk/ \
      && rm -rf /usr/share/doc/*
