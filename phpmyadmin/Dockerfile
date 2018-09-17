FROM registry.local.lan:5000/armv7h/archlinux

# install needed packages
RUN pacman -Sy --noconfirm \
    phpmyadmin \
    lighttpd \
    fcgi \
    php-fpm \
    php-gd \
    supervisor

RUN pacman -Scc

# cleanup phpmyadmin install
RUN rm -rf \
    /usr/share/webapps/phpMyAdmin/setup \
    /usr/share/webapps/phpMyAdmin/examples \
    /usr/share/webapps/phpMyAdmin/test \
    /usr/share/webapps/phpMyAdmin/po \
    /usr/share/webapps/phpMyAdmin/composer.json \ 
    /usr/share/webapps/phpMyAdmin/RELEASE-DATE-$VERSION;
    
RUN sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/webapps/phpmyadmin/');@" /usr/share/webapps/phpMyAdmin/libraries/vendor_config.php;
    
# Add directory for sessions to allow session persistence
RUN mkdir /sessions; \
    mkdir -p /usr/share/webapps/phpMyAdmin/tmp; \
    chown -R http:http /usr/share/webapps/phpMyAdmin/tmp /sessions

# fix permission
RUN chown http:http /run/php-fpm; \
    touch /var/log/php-fpm.log; \
    chown http:http /var/log/php-fpm.log

# Copy configuration
COPY etc /etc/

# Copy main script
COPY run.sh /run.sh

# We expose phpMyAdmin on port 80
EXPOSE 80

ENTRYPOINT [ "/run.sh" ]
CMD ["supervisord", "-n"]
