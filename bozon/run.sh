#!/bin/sh

# restore a previous backup (tar.gz archive) if any
if [ -f /mnt/bozon_conf_site_share.tar.gz ] ; then
    echo "found a backup for configuration, trying to restore..."
    cd /private
    tar -zxf bozon_conf_site_share.tar.gz 
fi

if [ -f /mnt/bozon_data_site_share.tar.gz ] ; then
    echo "found a backup for data (uploads), trying to restore..."
    cd /uploads
    tar -zxf bozon_data_site_share.tar.gz 
fi


mkfifo -m 600 /tmp/logpipehttp
cat <> /tmp/logpipehttp 1>&2 &
chown http /tmp/logpipehttp

exec "$@"
