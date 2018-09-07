Image usage
===========

Build an docker image for a simple file sharing app named BoZon.

Application is fetched from github uring the build from 
https://github.com/broncowdd/BoZoN

Env variables:
--------------
The following environement variable MUST be set:

- BOZON_MAX_UPLOAD : define my file size for upload (depends on php.ini settings, default to 256 Mb)
- BOZON_MAX_PROFILE_SIZE: define the storage size for each profile in Mb
- BOZON_CRON_SECURITY: a random string to protect cron page calls

Storage:
--------
- Uploads path is /uploads
- private path is /private (for settings storage).

Both directories should be pointed to a volume for persistence.

Example (no volume):
--------------------
docker run -p 8080:80 -e "BOZON_MAX_UPLOAD=256" -e "BOZON_MAX_PROFILE_SIZE=1024" -e "BOZON_CRON_SECURITY='SJfubAwo28dADJFqgsak'" --name bozon bozon_image