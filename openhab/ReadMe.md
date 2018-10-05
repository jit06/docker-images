Image usage
===========

This image inherit from the official openhab arm (alpine flavor).
I just added a way to restore volume from a previous backup uppon first start of the container.

First start:
------------
if a file ($BACKUP_CONF_ARCHIVE) is found in /mnt, it will be used to restore /openhab/conf

if a file ($BACKUP_DATA_ARCHIVE) is found in /mnt, it will be used to restore /openhab/userdata


Environements variables :
-------------------------

- BACKUP_CONF_ARCHIVE : filename of the tar.gz file to restore (from /mnt) to /openhab/conf
- BACKUP_DATA_ARCHIVE : filename of the tar.gz file to restore (from /mnt) to /openhab/userdata


Run Openhab:
--------------
Nothing special here.

**Example:** docker run --name openhab -e "BACKUP_CONF_ARCHIVE=conf_openhab.tar.gz" -e "BACKUP_DATA_ARCHIVE=data_openhab.tar.gz" --net=host -v conf_openhab:/openhab/conf -v data_openhab:/openhab/userdata -v /home/backup/conf_openhab.tar.gz:/mnt/conf_openhab.tar.gz -v /home/backup/data_openhab.tar.gz:/mnt/data_openhab.tar.gz openhab