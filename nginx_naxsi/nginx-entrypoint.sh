#!/bin/bash

# restore configuration from a backup if any
if [ -f /mnt/$BACKUP_CONF_ARCHIVE ] && [ ! -f /etc/nginx/restored ] ; then
    echo "found a backup for conf.d (/mnt/$BACKUP_CONF_ARCHIVE), trying to restore..."
    cd /etc/nginx
    tar -zxf /mnt/$BACKUP_CONF_ARCHIVE
    chown -R http /etc/nginx
    touch /etc/nginx/restored
fi

# restore configuration from a backup if any
if [ -f /mnt/$BACKUP_LE_ARCHIVE ] && [ ! -f /etc/letsencrypt/restored ] ; then
    echo "found a backup for letsencrypt (/mnt/$BACKUP_LE_ARCHIVE), trying to restore..."
    cd /etc/letsencrypt
    tar -zxf /mnt/$BACKUP_LE_ARCHIVE
    touch /etc/letsencrypt/restored
fi

if [ -f /etc/nginx/ssl_hosts ] ; then
    certbot certonly --noninteractive --agree-tos --config /etc/nginx/letsencrypt_init.ini
    /usr/local/bin/letsencrypt_renew.sh &
fi

if [ ! -d /var/tmp/nginx/temp ]; then
	mkdir -p /var/tmp/nginx/temp
fi

# if command starts with an option, prepend /usr/bin/nginx
if [ "${1:0:1}" = '-' ]; then
	set -- /usr/bin/nginx "$@"
fi

echo "Launch nginx with given arguments:"
echo "$@"
exec "$@"
