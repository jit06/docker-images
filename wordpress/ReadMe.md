Image usage
===========

Wordpress images that uses nginx and php-fpm.
This image provides the following features:

- included support for w3c total cache plugin
- robots.txt
- favicon.ico (from wp_content)
- access from an https reverse proxy
- autorestore wp-content from a tar.gz backup from /mnt


Also, the following php modules are activated:

- gd
- bz2
- exif
- iconv
- tidy
- imap
- apcu


Environements variables :

- NGINX_SERVER_NAME : virtual hosts to set nginx to
- SITEMAP_DOMAIN : domain name used to access sitemap in robots.txt
- WORDPRESS_DB_NAME : name of the database to use
- WORDPRESS_DB_USER : mysql user
- WORDPRESS_DB_PASS : mysql password
- WORDPRESS_DB_HOST : mysql server
- WORDPRESS_AUTH_KEY : one of the wordpress salt
- WORDPRESS_SECURE_AUTH_KEY : one of the wordpress salt
- WORDPRESS_LOGGED_IN_KEY : one of the wordpress salt
- WORDPRESS_NONCE_KEY : one of the wordpress salt
- WORDPRESS_AUTH_SALT : one of the wordpress salt
- WORDPRESS_SECURE_AUTH_SALT : one of the wordpress salt
- WORDPRESS_LOGGED_IN_SALT : one of the wordpress salt
- WORDPRESS_NONCE_SALT : one of the wordpress salt
- BACKUP_ARCHIVE : filename of the tar.gz file to restore from /mnt
