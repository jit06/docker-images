FROM registry.local.lan:5000/armv7h/archlinux

# install needed packages
RUN pacman -Sy --noconfirm \
    nginx \
    certbot
    
RUN pacman -Scc

# add directories for additionnal conf (throught volumes)
RUN mkdir /etc/nginx/conf.d

ADD ./nginx-entrypoint.sh /opt/nginx-entrypoint.sh
ADD ./letsencrypt_renew.sh /usr/local/bin/letsencrypt_renew.sh

#ADD ./nx_util-1.1.tar.gz /opt/

ENTRYPOINT ["/opt/nginx-entrypoint.sh"]

CMD [/usr/sbin/nginx]

