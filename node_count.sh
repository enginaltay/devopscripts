#!/bin/bash

COUNTER=0
DESIRED_COUNT=3

docker -H tcp://<swarm_endpoint_here>:2375 swarm join-token worker | tail -2 | tr -d "\r\n" | sh

sleep 5;

docker -H tcp://<swarm_endpoint_here>:2375 node update --label-add type=pubsub $(docker -H tcp://<swarm_endpoint_here>:2375 node ls | grep $(hostname) | awk '{print $1}')

NODE_COUNT=$(docker node ls -q --filter name=ip | xargs docker node inspect -f '{{ .ID }} [{{ .Description.Hostname }} {{.Status.State}}]' | grep "ready" | wc -l)


if [ "$DESIRED_COUNT" -eq "$NODE_COUNT" ]; then
	
	echo "Node Count is eqaul"

else

	echo "Not equal"

fi

