#!/bin/bash

# init db on first time exec
if [ ! -f /var/lib/mysql/ibdata1 ]; then

    echo "First run, launch mysql_install_db..."
    /usr/bin/mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

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
	
	echo "====================================================="
	echo "found a backup, start restore / upgrade procesure"
	echo "====================================================="
	echo ""
	echo "==== start restoring all databases ===="
        mysql -u $MARIADB_ROOT_USER -p$MARIADB_ROOT_PWD < /mnt/all-databases.sql
	echo "==== 	databases restored 	 ===="
	echo ""
	echo "==== kill mysql before starting upgrade ==="
	pkill -e mysqld
        pkill -e mariadb
        sleep 10s

	echo "==== start mysql with skip grant tables ===="    
        /usr/bin/mysqld -u root --skip-grant-tables &
	sleep 10s	

	echo "==== starting upgrade... ===="	
        mariadb-upgrade

	echo "====================================================="
	echo " Restore / upgrade procesure finished"
	echo "====================================================="
    	echo ""
    fi
    
    echo "kill mysql before restarting it with all arguments"
    pkill -e mysqld
    pkill -e mariadb
    sleep 10s
fi

# if command starts with an option, prepend /usr/bin/mysqld_safe
if [ "${1:0:1}" = '-' ]; then
	echo "arguments detected, adding them to the launch command"
	set -- /usr/bin/mysqld_safe "$@"
fi

echo "Launching safe_mysqld:"
echo "$@"
exec "$@"
