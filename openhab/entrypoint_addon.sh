#!/bin/bash -x

# restore config if backup found
if [ -f /mnt/$BACKUP_CONF_ARCHIVE ] && [ ! -f /conf_restored ] ; then
    echo "found a backup for /openhab/conf (/mnt/$BACKUP_CONF_ARCHIVE), trying to restore..."
    cd /openhab/conf
    tar -zxf /mnt/$BACKUP_CONF_ARCHIVE
    chown -R 9001:9001 /openhab/conf
    touch /conf_restored
fi

# restore data if backup found
if [ -f /mnt/$BACKUP_DATA_ARCHIVE ] && [ ! -f /data_restored ] ; then
    echo "found a backup for /openhab/userdata (/mnt/$BACKUP_DATA_ARCHIVE), trying to restore..."
    cd /openhab/userdata
    tar -zxf /mnt/$BACKUP_DATA_ARCHIVE
    rm -Rf /openhab/userdata/tmp/*
    rm -Rf /openhab/userdata/cache/*
    rm -Rf /openhab/userdata/log/*
    chown -R 9001:9001 /openhab/userdata
    touch /data_restored
fi

cd /openhab
