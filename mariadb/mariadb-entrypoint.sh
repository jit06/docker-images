#!/bin/bash

# init db on first time exec
if [ ! -f /var/lib/mysql/ibdata1 ]; then

    /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    /usr/bin/mysqld_safe &
    sleep 10s
    
    # securize a bit...
    echo "GRANT ALL ON *.* TO $MARIADB_ROOT_USER@'%' IDENTIFIED BY '$MARIADB_ROOT_PWD' WITH GRANT OPTION; DROP DATABASE test;" | mysql
    echo "GRANT ALL ON *.* TO $MARIADB_ROOT_USER@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PWD' WITH GRANT OPTION;" | mysql
    echo "DELETE FROM mysql.user WHERE User='root'; FLUSH PRIVILEGES;" | mysql

    # restore a previous backup (from mysqldump --all-databases) if any
    if [ -f /mnt/sql/all-databases.sql ] ; then
        mysql -u $MARIADB_ROOT_USER -p$MARIADB_ROOT_PWD < /mnt/sql/all-databases.sql
    fi
    
    killall mysqld
    sleep 10s
fi


# if command starts with an option, prepend /usr/bin/mysqld_safe
if [ "${1:0:1}" = '-' ]; then
	set -- /usr/bin/mysqld_safe "$@"
fi

exec "$@"

