#!/bin/bash

ALERT_SIZE=6442450944 #6GB
#8589934592 #8GB
ALERT_SIZE_IN_GB="$(( ${ALERT_SIZE%% *} / 1024 / 1024 / 1024)) GB"

#Calculate /var/lib/docker size & create alert
VOLUME_DIR=${volume_dir:-"/var/lib/docker/volumes/*"}
DOCKER_DIR=${docker_dir:-"/var/lib/docker/*"}
echo "Disk usage of docker related folders:\n`du -shc ${DOCKER_DIR}`"

#List Docker Swarm Services
#echo "Listing Docker Services...:\n`docker service ls --format {{.Name}}`"

#List Docker Containers
#echo "Listing Docker Containers...:\n`docker ps -s --format '{{.ID}}\t {{.Names}}\t {{.Size}}'`"

#List Docker Volume Sizes
printf "Listing Docker Volumes with Size...:\n`du -b ${VOLUME_DIR}`"
VOLUME_SIZE=$(printf "\n`du -bc ${VOLUME_DIR}`" | awk '{ total = $1 }; END { print total }')
printf "\nTotal Docker Volume Size is: ${VOLUME_SIZE}\n"

if [ "$VOLUME_SIZE" -gt "$ALERT_SIZE" ]; then

        NOTIF=$(printf "\n-----Notification Type: Warning-----")
        echo "Total Docker Volume size is bigger than ${ALERT_SIZE}"
        TEXT1=$(echo "\n\n-----Swarm Node-----")
        printf "`docker node inspect --format='{{.ID}}''\n''{{.Description.Hostname}}''\n''{{.Description.Engine.EngineVersion}}' self`\n"
        SWARM_INFO=$(printf '\n'"`docker node inspect --format='{{.ID}}''\n''{{.Description.Hostname}}''\n''{{.Description.Engine.EngineVersion}}''\n' self`")
        TEXT2=$(echo "\n\n-----Containers-----")
        echo "`docker ps -s --format '{{.ID}}\t {{.Names}}\t {{.Size}}'`"
        CONTAINER_INFO=$(printf '\n'"`docker ps -s --format '{{.ID}}\t {{.Names}}\t {{.Status}}\t {{.Size}}'`")
        TEXT3=$(echo "\n\n-----Volume-----")
        echo "`du -bsc ${VOLUME_DIR}`"
        VOLUME_INFO=$(printf '\n'"`du -shc ${VOLUME_DIR}`")
        TEXT4=$(echo "Date/Time: `date +%d-%m-%Y`/`date +%T`")
        DATE_INFO=$(printf '\n\n'"Date/Time: `date +%d-%m-%Y`/`date +%T`")


        aws sns publish --topic-arn "<sns_arn_here>" \
        --region eu-central-1 \
        --subject "Alert! Total Docker Volume Size is Bigger than ${ALERT_SIZE_IN_GB}" \
        --message "${NOTIF} ${TEXT1} ${SWARM_INFO} ${TEXT2} ${CONTAINER_INFO} ${TEXT3} ${VOLUME_INFO} ${DATE_INFO}"

else
	echo "Nothing to worry about."

fi