Image usage
===========

Reverse proxy + WAF using Nginx, naxsi and letsencrypt for https offloading.
A refresh of letsencrypt certificates is tried once a day

First start:
------------
if a file ($BACKUP_CONF_ARCHIVE) is found in /mnt, it will be used to restore /etc/nginx/conf.d

if a file ($BACKUP_LE_ARCHIVE) is found in /mnt, it will be used to restore /etc/letsencrypt


Environements variables :
-------------------------

- BACKUP_CONF_ARCHIVE : filename of the tar.gz file to restore (from /mnt) to /etc/nginx/conf.d
- BACKUP_LE_ARCHIVE : filename of the tar.gz file to restore (from /mnt) to /etc/letsencrypt
- WORKER_PROCESS : number of worker process (1 per cpu)
- WORKER_CONNECTIONS : number of connections allowed per process


Run Nginx:
----------

to run it, you must have nginx configuration files /etc/nginx/conf.d:
- base_conf : nginx main configuration file
- letsencrypt.ini : parameters for letsencrypt
- naxsi_rules : folder to store naxsi configurations
- reverse_conf : folder to store reverse proxy settings

**Example:** docker run -name "reverseproxy" -p 80 -p 443 -e "$BACKUP_CONF_ARCHIVE=myconf.tar.gz" -e "$BACKUP_LE_ARCHIVE=myLEconf.tar.gz" -e "WORKER_PROCESS=4" -e "WORKER_CONNECTIONS=512" -v conf_rproxy:/etc/nginx/conf.d -v conf_rproxy_letsencrypt:/etc/letsencrypt
