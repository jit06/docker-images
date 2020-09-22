FROM arm32v7/alpine

# default env var
ENV MARIADB_ROOT_USER admin
ENV MARIADB_ROOT_PWD admin

RUN apk add --no-cache mariadb mariadb-server-utils mariadb-client bash && \
    rm -f /var/cache/apk/*

# seems not done by the package....?
#RUN echo "mysql:x:89:89:MariaDB daemon:/var/lib/mysql:/bin/false" >> /etc/passwd
#RUN echo "mysql:x:89:" >> /etc/group

RUN rm -Rf /var/lib/mysql/*
RUN mkdir -p /run/mysqld && chown mysql /run/mysqld

EXPOSE 3306

ADD ./mariadb-entrypoint.sh /opt/mariadb-entrypoint.sh
ADD ./mysqltuner.pl /opt/mysqltuner.pl
ADD ./basic_passwords.txt /opt/basic_passwords.txt
ADD ./vulnerabilities.csv /opt/vulnerabilities.csv

ENTRYPOINT ["/opt/mariadb-entrypoint.sh"]

CMD ["/usr/bin/mysqld_safe"]
