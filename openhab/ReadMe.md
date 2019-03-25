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
- TIMEZONE : set timezone for localtime (eg: Europe/Paris)

Run Openhab:
--------------
Nothing special here, except that env vars should be set to get the correct timezone in openhab : TZ and EXTRA_JAVA_OPTIONS

**Example:** docker run --name openhab -e "BACKUP_CONF_ARCHIVE=myconf_openhab.tar.gz" -e "BACKUP_DATA_ARCHIVE=mydata_openhab.tar.gz" -e "TZ=Europe/Berlin" -e 'EXTRA_JAVA_OPTIONS="-Duser.timezone=Europe/Paris"' --net=host -v conf_openhab:/openhab/conf -v data_openhab:/openhab/userdata -v /home/backup/conf_openhab.tar.gz:/mnt/conf_openhab.tar.gz -v /home/backup/data_openhab.tar.gz:/mnt/data_openhab.tar.gz openhab


Misc :
------
If running on ARM big.LITTLE architecture, you may need to force the container to stay only on big or little core to avoid crash of the JVM:
**Example with Odroid XU4**: docker update --cpuset-cpus "4-7" <container_id>
