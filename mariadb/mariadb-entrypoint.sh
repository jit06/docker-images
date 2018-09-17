#!/bin/bash

# init db on first time exec
if [ ! -f /var/lib/mysql/ibdata1 ]; then

    echo "First run, launch mysql_install_db..."
    /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    # link error file to /dev/stderr if it does not exist yet
    mysql_error_log=$(hostname).err
    echo "Create symlink to redirect error log to /dev/sterr"
    ln -s /dev/stdout /var/lib/mysql/$mysql_error_log
    chown mysql:mysql /var/lib/mysql/$mysql_error_log

    echo "Init db done, start mysqld_safe..."
    /usr/bin/mysqld_safe &
    sleep 10s

    # securize a bit...
    echo "securize default settings..."
    echo "GRANT ALL ON *.* TO $MARIADB_ROOT_USER@'%' IDENTIFIED BY '$MARIADB_ROOT_PWD' WITH GRANT OPTION; DROP DATABASE test;" | mysql
    echo "GRANT ALL ON *.* TO $MARIADB_ROOT_USER@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PWD' WITH GRANT OPTION;" | mysql
    echo "DELETE FROM mysql.user WHERE User='root'; FLUSH PRIVILEGES;" | mysql

    # restore a previous backup (from mysqldump --all-databases) if any
    if [ -f /mnt/all-databases.sql ] ; then
	echo "found a backup, trying to restore..."
        mysql -u $MARIADB_ROOT_USER -p$MARIADB_ROOT_PWD < /mnt/all-databases.sql
    fi
    
    echo "All init done, kill mysql before relaunching it..."
    pkill mysqld
    sleep 10s
fi

# if command starts with an option, prepend /usr/bin/mysqld_safe
if [ "${1:0:1}" = '-' ]; then
	set -- /usr/bin/mysqld_safe "$@"
fi

echo "Launch safe_mysqld with given arguments:"
echo "$@"
exec "$@"

