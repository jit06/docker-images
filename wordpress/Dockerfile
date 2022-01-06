FROM arm32v7/alpine

# install needed packages
RUN apk add --no-cache bash curl less vim nginx ca-certificates git tzdata zip supervisor \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    php7-fpm php7-json php7-zlib php7-xml php7-xmlwriter php7-simplexml php7-pdo php7-phar php7-openssl \
    php7-pdo_mysql php7-mysqli php7-session php7-imap php7-tidy \
    php7-gd php7-iconv php7-mcrypt php7-gmp php7-zip \
    php7-curl php7-opcache php7-ctype php7-apcu \
    php7-intl php7-bcmath php7-dom php7-mbstring php7-xmlreader mysql-client curl && apk add -u musl && \
    rm -rf /var/cache/apk/*

# create http user
RUN adduser --disabled-password --no-create-home http && addgroup 'http' http

# Add directory for sessions and pid
RUN mkdir /sessions /srv/http; \
    chown -R http:http /srv/http /sessions /var/lib/nginx

# fix permission
RUN touch /var/log/php-fpm.log; \
    chown http:http /var/log/php-fpm.log
    
# get latest worpress
RUN set -ex; \
	curl -o wordpress.tar.gz -fSL "https://wordpress.org/latest.tar.gz"; \
	tar -xzf wordpress.tar.gz -C /srv/http; \
	rm wordpress.tar.gz; \
	rm /srv/http/wordpress/readme.html; \
	rm /srv/http/wordpress/license.txt

# Copy configuration
COPY etc /etc/
COPY robots.txt /srv/http/wordpress

# Copy main script
COPY run.sh /run.sh

# We expose nginx on port 80
EXPOSE 80

ENTRYPOINT [ "/run.sh" ]
CMD ["supervisord", "-n"]
