#!/bin/sh

# use env vars to adjust runtime configuration
if [ ! -f /configured ]; then
    touch /configured
    sed -i -e "s/NGINX_SERVER_NAME/${NGINX_SERVER_NAME}/g" /etc/nginx/conf.d/wordpress.conf
    
    sed -i -e "s/SITEMAP_DOMAIN/${SITEMAP_DOMAIN}/g" /srv/http/wordpress/robots.txt
    
    cp /srv/http/wordpress/wp-config-sample.php /srv/http/wordpress/wp-config.php
    sed -i -e "s/database_name_here/${WORDPRESS_DB_NAME}/g" /srv/http/wordpress/wp-config.php
    sed -i -e "s/username_here/${WORDPRESS_DB_USER}/g"      /srv/http/wordpress/wp-config.php
    sed -i -e "s/password_here/${WORDPRESS_DB_PASS}/g"      /srv/http/wordpress/wp-config.php
    sed -i -e "s/localhost/${WORDPRESS_DB_HOST}/g"          /srv/http/wordpress/wp-config.php
    
    
    sed -i -e "s/'AUTH_KEY',         'put your unique phrase here'/'AUTH_KEY',         '${WORDPRESS_AUTH_KEY}'/g"         /srv/http/wordpress/wp-config.php
    sed -i -e "s/'SECURE_AUTH_KEY',  'put your unique phrase here'/'SECURE_AUTH_KEY',  '${WORDPRESS_SECURE_AUTH_KEY}'/g"  /srv/http/wordpress/wp-config.php
    sed -i -e "s/'LOGGED_IN_KEY',    'put your unique phrase here'/'LOGGED_IN_KEY',    '${WORDPRESS_LOGGED_IN_KEY}'/g"    /srv/http/wordpress/wp-config.php
    sed -i -e "s/'NONCE_KEY',        'put your unique phrase here'/'NONCE_KEY',        '${WORDPRESS_NONCE_KEY}'/g"        /srv/http/wordpress/wp-config.php
    sed -i -e "s/'AUTH_SALT',        'put your unique phrase here'/'AUTH_SALT',        '${WORDPRESS_AUTH_SALT}'/g"        /srv/http/wordpress/wp-config.php
    sed -i -e "s/'SECURE_AUTH_SALT', 'put your unique phrase here'/'SECURE_AUTH_SALT', '${WORDPRESS_SECURE_AUTH_SALT}'/g" /srv/http/wordpress/wp-config.php
    sed -i -e "s/'LOGGED_IN_SALT',   'put your unique phrase here'/'LOGGED_IN_SALT',   '${WORDPRESS_LOGGED_IN_SALT}'/g"   /srv/http/wordpress/wp-config.php
    sed -i -e "s/'NONCE_SALT',       'put your unique phrase here'/'NONCE_SALT',       '${WORDPRESS_NONCE_SALT}'/g"       /srv/http/wordpress/wp-config.php

    sed -i -e "s/define('WP_DEBUG', false)/define('WP_DEBUG', '${WORDPRESS_DEBUG}')/g" /srv/http/wordpress/wp-config.php
    sed -i -e "s/<?php/<?php if ( (!empty( \$_SERVER['HTTP_X_FORWARDED_HOST'])) || (!empty( \$_SERVER['HTTP_X_FORWARDED_FOR'])) ) { \$_SERVER['HTTP_HOST'] = \$_SERVER['HTTP_X_FORWARDED_HOST']; define('WP_HOME', 'https:\/\/$SITEMAP_DOMAIN');define('WP_SITEURL', 'https:\/\/$SITEMAP_DOMAIN');\$_SERVER['HTTPS'] = 'on';}/g" /srv/http/wordpress/wp-config.php
 
    echo "define('FS_METHOD', 'direct');" >>  /srv/http/wordpress/wp-config.php
    echo "error_reporting( E_ALL ^ ( E_NOTICE | E_WARNING | E_DEPRECATED ) );" >> /srv/http/wordpress/wp-config.php    
fi

# restore wp-content from a backup if any
if [ -f /mnt/$BACKUP_ARCHIVE ] && [ ! -f /srv/http/wordpress/wp-content/restored ] ; then
    echo "found a backup for wp-content (/mnt/$BACKUP_ARCHIVE), trying to restore..."
    cd /srv/http/wordpress/wp-content
    tar -zxf /mnt/$BACKUP_ARCHIVE
    chown -R http:http /srv/http/wordpress/wp-content
    touch /srv/http/wordpress/wp-content/restored
fi

# link favicon to root if any in wp-content
if [ -f /srv/http/wordpress/wp-content/favicon.ico ] ; then
    echo "found a favicon in wp-content, linking it from root"
    cd /srv/http/wordpress
    ln -s wp-content/favicon.ico
fi


exec "$@"
