#!/bin/bash

#Clean dangling docker images and voluems
docker rmi $(docker images -a -q --no-trunc --filter "dangling=true") | tee /opt/devops/image_cleaner_$(date -I).log

#Clean unused / dead docker containers
docker rm $(docker ps -qa --no-trunc --filter "status=exited" -f "status=dead") | tee /opt/devops/container_cleaner_$(date -I).log

#Clean dangling unused docker volumes
docker volume ls -qf dangling=true | xargs docker volume rm | tee /opt/devops/volume_cleaner_$(date -I).log
