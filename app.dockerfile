FROM php:8.0.2-fpm-buster

RUN apt-get update && apt-get install --no-install-recommends -y \
        less

ARG WITH_XDEBUG=false
ARG XDEBUG_TRIGGER_PROFILER=false
ARG XDEBUG_PROFILER_DIR=/var/xdebug

RUN if [ ${WITH_XDEBUG} = "true" ] ; then \
        pecl install xdebug-3.0.3; \
        docker-php-ext-enable xdebug; \
        echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        if [ ${XDEBUG_TRIGGER_PROFILER} = "true" ] ; then \
            echo xdebug.mode=profile >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
            echo xdebug.start_with_request=trigger >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
            echo xdebug.output_dir=${XDEBUG_PROFILER_DIR} >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        fi ; \
    fi ;

RUN apt-get --allow-releaseinfo-change update \
    && curl -sL https://deb.nodesource.com/setup_15.x | bash -

RUN apt-get update && apt-get install -y \
    nodejs \
    libmcrypt-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    zip \
    unzip \
    mariadb-client \
    libmagickwand-dev \
    ghostscript --no-install-recommends \
    imagemagick \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && pecl install mcrypt-1.0.4 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl

ENV TIMEZONE=America/Chicago
ENV TZ=America/Chicago

RUN touch /usr/local/etc/php/conf.d/dates.ini \
    && echo "date.timezone = $TZ;" >> /usr/local/etc/php/conf.d/dates.ini

RUN touch /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN touch /usr/local/etc/php/conf.d/docker-php-upload-settings.ini \
    && echo "max_execution_time = 180" >> /usr/local/etc/php/conf.d/docker-php-upload-settings.ini \
    && echo "post_max_size = 512M" >> /usr/local/etc/php/conf.d/docker-php-upload-settings.ini \
    && echo "upload_max_filesize = 256M" >> /usr/local/etc/php/conf.d/docker-php-upload-settings.ini

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
RUN apt-get update && apt-get install -y
RUN chown -R www-data:www-data /var/www
RUN chmod 777 -R /tmp && chmod o+t -R /tmp
