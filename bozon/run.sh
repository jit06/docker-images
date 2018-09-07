#!/bin/sh

# restore a previous backup (from mysqldump --all-databases) if any
if [ -f /mnt/sql/all-databases.sql ] ; then
    echo "found a backup, trying to restore..."
fi


mkfifo -m 600 /tmp/logpipehttp
cat <> /tmp/logpipehttp 1>&2 &
chown http /tmp/logpipehttp

exec "$@"
