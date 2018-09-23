Image usage
===========

Wordpress images that uses nginx and php-fpm.
This image provides the following features:

- included support for w3c total cache plugin
- robots.txt
- favicon.ico (from wp_content)
- access from an https reverse proxy
- autorestore wp-content from a tar.gz backup from /mnt
- change debug state (true or false)
- set wordpress upgrade mode to direct (for plugins)

Also, the following php modules are activated:

- gd
- bz2
- exif
- iconv
- tidy
- imap
- apcu


First start:
------------
During the first start, the latest wordpress archive is downloaded and deployed to /srv/http. 
A volume can be mount to bind /srv/http/wordpress/wp-content.

Wordpress should be able to upgrade your DB schema if it is not in the right version.

if a file ($BACKUP_ARCHIVE) is found in /mnt, it will be used to restore /srv/http/wordpress/wp-content


Environements variables :
-------------------------

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
- WORDPRESS_DEBUG : either true or false
- BACKUP_ARCHIVE : filename of the tar.gz file to restore from /mnt

Run Wordpress:
--------------
Nothing special here.

**Example:** docker run -p 8081:80 -e "NGINX_SERVER_NAME=mysite.com www.mysite.com" -e "SITEMAP_DOMAIN=www.mysite.com" -e "WORDPRESS_DEBUG=false"  -e "WORDPRESS_DB_NAME=dbname" -e "WORDPRESS_DB_USER=sqluser" -e "WORDPRESS_DB_PASS=sqlpassword" -e "WORDPRESS_DB_HOST=maria_db" -e "WORDPRESS_AUTH_KEY=09f4568j92dj3iuh9sdf98sj" -e "WORDPRESS_SECURE_AUTH_KEY=skldf82u398erg57fojjoiw" -e "WORDPRESS_LOGGED_IN_KEY=sdjfwfhr723ziuwhfiuh9812" -e "WORDPRESS_NONCE_KEY=98723hfhbsdfsfuihsdf87237" -e "WORDPRESS_AUTH_SALT=98jkipoqwpondfsdfuihw83878734" -e "WORDPRESS_SECURE_AUTH_SALT=qwpkjbsdfsf34trfuz762389ukhd" -e "WORDPRESS_LOGGED_IN_SALT=4629ug93hj456656zrtgdow98wh98f" -e "WORDPRESS_NONCE_SALT=las456zrgf2oz47wvwiw8fhj72t32" -e "BACKUP_ARCHIVE=mysite.tar.gz" -v /path/to/backup/mysite.tar.gz:/mnt/mysite.tar.gz  --name wordpress ed5e898bff26

