FROM registry.local.lan:5000/armv7h/archlinux

RUN pacman -Sy --noconfirm openssl mosquitto
RUN pacman -Scc

CMD ["/usr/bin/mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]
