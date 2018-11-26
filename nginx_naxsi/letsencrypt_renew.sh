#!/bin/bash

while true
do
	sleep 1d
	certbot certonly --noninteractive --agree-tos --config /etc/nginx/conf.d/letsencrypt.ini
done
