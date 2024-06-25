#!/bin/bash

docker network ls | grep -q newNetwork || docker network create newNetwork

if [ ! -d "app" ]; then
  mkdir app
fi

wget https://wordpress.org/latest.tar.gz -O wordpress.tar.gz
tar -xzf wordpress.tar.gz -C app

docker run -d --network newNetwork --name db -e MYSQL_ROOT_PASSWORD=lesupermdp -e MYSQL_DATABASE=wordpress -v db_data:/var/lib/mysql mysql:8.0

docker run -d --network newNetwork --name script -v $(pwd)/app:/app php:8.3.7-fpm bash -c "docker-php-ext-install mysqli && docker-php-ext-enable mysqli && php-fpm"

docker run -p 8080:80 -d --name http -v $(pwd)/app:/app -v $(pwd)/default.conf:/etc/nginx/conf.d/default.conf --network reseau nginx:1.25

docker exec -it http nginx -s reload
