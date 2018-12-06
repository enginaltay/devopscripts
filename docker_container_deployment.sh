#!bin/bash

USERNAME="dockerhubusername"
PASSWORD="dockerhubpassword"

#Login Docker Registry
docker login --username=$USERNAME --password=$PASSWORD

#Pull new docker image
docker pull wordpress:4.9.1-php7.0-apache

#Stop & Remove current docker container
docker stop my-wordpress
docker rm -f my-wordpress

#Create new wordpress docker container
docker run \
--name my-wordpress \
-h $(hostname) \
--restart=always \
--link my-mariadb:mysql \
-p 0.0.0.0:8080:80 \
-d wordpress:4.9.1-php7.0-apache
