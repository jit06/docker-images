FROM registry.local.lan:5000/armv7h/archlinux

# install needed packages
RUN pacman -Sy --noconfirm \
    nginx \
    php-fpm \
    php-gd \
    php-apcu \
    php-apcu-bc \
    php-imap \
    php-tidy \
    supervisor

RUN pacman -Scc


# Add directory for sessions to allow session persistence
RUN mkdir /sessions; \
    chown -R http:http /srv/http /sessions

# fix permission
RUN chown http:http /run/php-fpm; \
    touch /var/log/php-fpm.log; \
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
