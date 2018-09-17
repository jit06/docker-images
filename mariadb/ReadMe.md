Image usage
===========

Env variables:
--------------
- MARIADB_ROOT_USER
- MARIADB_ROOT_PWD

Both default to "admin" and *should be changed*

First start:
------------
During the first start, user root is deleted, and the given user (MARIADB_ROOT_USER) is created with all privileges.

If /mnt contains a file named all-databases.sql, this file is passed to mysql, allowing an automated restore.

Run MariaDB:
------------
run the image with arguments, and the will be directly passed to safe_mysqld.
arguments that *should be set* to configure it correctly:

- port
- socket
- skip-external-locking
- key_buffer_size
- max_allowed_packet
- table_open_cache
- sort_buffer_size
- net_buffer_length
- read_buffer_size
- read_rnd_buffer_size
- myisam_sort_buffer_size
- innodb_buffer_pool_size
- query_cache_limit
- query_cache_size
- tmp_table_size
- max_heap_table_size
- innodb_buffer_pool_instances
- max_connections

**Example:** docker run -d -p 3306:3306 --name test_mariadb -v /path/to/backup:/mnt registry.local.lan:5000/mariadb --port 3306 --skip-external-locking

In order to get all logs trapped with docker you could also add:

- log-warnings
- slow-query-log
- slow-query-log-file /dev/stdout
- general-log
- general-log-file /dev/stdout

Note : error log are automaticaly sent to stdout

Launch an audit:
----------------
The image contains mysqltuner.pl script and some known vulnerabilities and easy to find password.

docker exec **mariadb_container** perl /opt/mysqltuner.pl --host localhost --user **my_user** --pass **my_password**
