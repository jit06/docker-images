FROM registry.local.lan:5000/armv7h/archlinux

# install needed packages
RUN pacman -Sy --noconfirm \
    nginx \
    nginx-mod-naxsi \
    certbot
    
RUN pacman -Scc

RUN useradd -r -s /usr/bin/nologin http ; \
    mkdir /etc/nginx/conf.d ; \
    chown http /etc/nginx/conf.d;

ADD ./nginx-entrypoint.sh /opt/nginx-entrypoint.sh
ADD ./letsencrypt_renew.sh /usr/local/bin/letsencrypt_renew.sh

#ADD ./nx_util-1.1.tar.gz /opt/

ENTRYPOINT ["/opt/nginx-entrypoint.sh"]

CMD ["/usr/bin/nginx"]
