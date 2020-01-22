#!/bin/bash

SERVICE=pubsub
COUNTER=0
DESIRED_COUNT=3

echo "Listing pubsub services...."


for i in $(docker service ps $SERVICE --format '{{.ID}}\t' -f desired-state=running)

do
	COUNTER=$((COUNTER+1))
        echo $COUNTER
	echo "$i"
done;

if [ "$COUNTER" -lt "$DESIRED_COUNT" ]; then
	echo "Current running Pubsub service number is less than ${DESIRED_COUNT}!!"
	echo "Sending Notification to DevOps & Web Teams"

	aws sns publish --topic-arn "<sns_arb_here>" --subject "Alert! Pubsub Docker Container Count is less than Desired Count!!" --message "The number of running pubsub services is below ${DESIRED_COUNT}!! Check the Docker Swarm services"
	aws sns publish --topic-arn "<sns_arn_here>" --subject "Alert! Pubsub Docker Container Count is less than Desired Count!!" --message "The number of running pubsub services is below ${DESIRED_COUNT}!! Check the Docker Swarm services"

	echo "Notification Successfully Sent."
else

	echo "Current and Desired docker service counts are equal. There is nothing to worry about"

fi
