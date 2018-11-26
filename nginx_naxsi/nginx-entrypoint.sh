#!/bin/bash

if [ ! -f /opt/configured ]; then
	echo "" > /etc/nginx/nginx.conf
	echo "error_log stderr ;" >> /etc/nginx/nginx.conf

	if [ "$WORKER_PROCESS" -ne 0 ] ; then
		echo "worker_processes $WORKER_PROCESS ;" >> /etc/nginx/nginx.conf
	fi
	
	if [ "$WORKER_CONNECTIONS" -ne 0 ] ; then
		echo "events {" >> /etc/nginx/nginx.conf
		echo "worker_connections $WORKER_CONNECTIONS ;" >> /etc/nginx/nginx.conf
		echo "}" >> /etc/nginx/nginx.conf
        fi

	echo "include /etc/nginx/conf.d/base_conf;" >> /etc/nginx/nginx.conf
	echo "include /etc/nginx/conf.d/reverse_conf/*;" >> /etc/nginx/nginx.conf
	echo "daemon off;" >> /etc/nginx/nginx.conf

	if [ -f /etc/nginx/conf.d/ssl_hosts ] ; then
		certbot certonly --noninteractive --agree-tos --config /etc/nginx/conf.d/letsencrypt_init.ini
	fi

	touch /opt/configured
fi


# restore configuration from a backup if any
if [ -f /mnt/$BACKUP_CONF_ARCHIVE ] && [ ! -f /etc/nginx/conf.d/restored ] ; then
    echo "found a backup for conf.d (/mnt/$BACKUP_CONF_ARCHIVE), trying to restore..."
    cd /etc/nginx/conf.d
    tar -zxf /mnt/$BACKUP_CONF_ARCHIVE
    chown -R http:http /etc/nginx/conf.d
    touch /etc/nginx/conf.d/restored
fi

# restore configuration from a backup if any
if [ -f /mnt/$BACKUP_LE_ARCHIVE ] && [ ! -f /etc/letsencrypt/restored ] ; then
    echo "found a backup for letsencrypt (/mnt/$BACKUP_LE_ARCHIVE), trying to restore..."
    cd /etc/letsencrypt
    tar -zxf /mnt/$BACKUP_LE_ARCHIVE
    touch /etc/letsencrypt/restored
fi


if [ -f /etc/nginx/conf.d/ssl_hosts ] ; then
	/usr/local/bin/letsencrypt_renew.sh &
fi


if [ ! -d /var/tmp/nginx/temp ]; then
	mkdir -p /var/tmp/nginx/temp
fi

echo "Launch nginx with /etc/nginx/nginx.conf"
exec "$@ -c /etc/nginx/nginx.conf"
