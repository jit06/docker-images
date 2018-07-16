#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <name> <port> <mysql conf volume> <mysql data volume>"
    exit 1
fi

docker run --restart=always -d -p $1:3306 --name $2 -v $3:/etc/mysql -v $4:/var/lib/mysql mysql
