FROM arm32v7/alpine

# default env var
ENV MARIADB_ROOT_USER admin
ENV MARIADB_ROOT_PWD admin

RUN apk add --no-cache mariadb mariadb-server-utils mariadb-client bash grep perl perl-doc wget procps && \
    rm -f /var/cache/apk/*

# do not use default settings
RUN rm /etc/my.cnf.d/mariadb-server.cnf

RUN rm -Rf /var/lib/mysql/*
RUN mkdir -p /run/mysqld && chown mysql /run/mysqld

EXPOSE 3306

ADD ./mariadb-entrypoint.sh /opt/mariadb-entrypoint.sh
ADD ./mysqltuner.pl /opt/mysqltuner.pl
ADD ./basic_passwords.txt /opt/basic_passwords.txt
ADD ./vulnerabilities.csv /opt/vulnerabilities.csv

ENTRYPOINT ["/opt/mariadb-entrypoint.sh"]

#CMD ["/usr/bin/mysqld_safe"]
