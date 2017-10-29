# Set the base image
FROM alpine:latest
# Dockerfile author / maintainer 
MAINTAINER Egor "ctepeo" Sazanovich <egor@prodev.io> 

# Install packages
RUN apk update && apk add --no-cache nginx \
    bash \
    curl \
    supervisor \
    tzdata \
    php7 \
	php7-curl \
	php7-dom \
	php7-fpm \
	php7-gd \
	php7-json \
	php7-intl \
	php7-mbstring \
	php7-mcrypt \
	php7-mysqli \
	php7-pdo \
	php7-phar \
	php7-opcache \
	php7-openssl \
	php7-session \
	php7-xml \
	php7-xmlreader \
	php7-zlib \
	&& rm -rf /var/cache/apk/*


# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# set timezone
ENV TZ=Europe/Minsk
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && date

# php composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

EXPOSE 80

# entrypoint
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]