#!/bin/sh
if [ ! -f /etc/webapps/phpmyadmin/config.secret.inc.php ]; then
    cat > /etc/webapps/phpmyadmin/config.secret.inc.php <<EOT
<?php
\$cfg['blowfish_secret'] = '$(tr -dc 'a-zA-Z0-9~!@#$%^&*_()+}{?></";.,[]=-' < /dev/urandom | fold -w 32 | head -n 1)';
EOT
fi

if [ ! -f /etc/webapps/phpmyadmin/config.user.inc.php ]; then
    touch /etc/webapps/phpmyadmin/config.user.inc.php
fi

mkfifo -m 600 /tmp/logpipehttp
cat <> /tmp/logpipehttp 1>&2 &
chown http /tmp/logpipehttp

exec "$@"
