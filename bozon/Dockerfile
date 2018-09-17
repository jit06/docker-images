FROM registry.local.lan:5000/armv7h/archlinux

# install needed packages
RUN pacman -Sy --noconfirm \
    lighttpd \
    fcgi \
    php-fpm \
    php-gd \
    unzip \
    supervisor

RUN pacman -Scc
  
# Add directory for sessions and uploads to allow session and file persistence
RUN mkdir /sessions;\
    mkdir /uploads; \
    mkdir /uploads/thumbs; \
    mkdir /private; \
    chown -R http:http /uploads /private /sessions
  
# retreive application
RUN set -ex; \
    curl --output bozon.zip --location https://github.com/broncowdd/BoZoN/archive/master.zip; \
    unzip bozon.zip -d /usr/share/webapps/; \
    rm bozon.zip; \
    mv /usr/share/webapps/BoZoN-master /usr/share/webapps/bozon; \
    rm /usr/share/webapps/bozon/*.md; \
    ln -s /uploads/thumbs /usr/share/webapps/bozon/thumbs ; \
    ln -s /private /usr/share/webapps/bozon/private ; \
    ln -s /uploads /usr/share/webapps/bozon/uploads ; \
    find /usr/share/webapps/bozon -type d -exec chmod 755 {} \; ; \
    find /usr/share/webapps/bozon -type f -exec chmod 644 {} \;


# fix permission
RUN chown http:http /run/php-fpm; \
    touch /var/log/php-fpm.log; \
    chown http:http /var/log/php-fpm.log    
    
    
# Copy configuration
COPY etc /etc/
COPY config.php /usr/share/webapps/bozon/
COPY robots.txt /usr/share/webapps/bozon/

# Copy main script
COPY run.sh /run.sh

# We expose phpMyAdmin on port 80
EXPOSE 80

ENTRYPOINT [ "/run.sh" ]
CMD ["supervisord", "-n"]
