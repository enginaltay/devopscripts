#!/bin/bash

docker -H tcp://<swarm_endpoint_here>:2375 swarm join-token worker | tail -2 | tr -d "\r\n" | sh > /tmp/isJoined.txt
sleep 5;
docker -H tcp://<swarm_endpoint_here>:2375 node update --label-add type=pubsub $(docker -H tcp://<swarm_endpoint_here>:2375 node ls | grep $(hostname) | awk '{print $1}')
while [ "$(docker -H tcp://<swarm_endpoint_here>:2375 node inspect $(docker -H tcp://<swarm_endpoint_here>:2375 node ls | grep $(hostname) | awk '{print $1}') -f '{{.Spec.Labels.type}}')" != "pubsub" ]; do	
	sleep 5;
	docker -H tcp://<swarm_endpoint_here>:2375 node update --label-add type=pubsub $(docker -H tcp://<swarm_endpoint_here>:2375 node ls | grep $(hostname) | awk '{print $1}')
done
echo "pubsub label ok" > /tmp/result.txt

cat << 'EOF' > /root/.aws/config
[default]
region = eu-central-1

[profile webasg]
region = eu-central-1
EOF

cat << 'EOF' > /root/.aws/credentials
[default]
aws_access_key_id = <access_key_here>
aws_secret_access_key = <secret_access_key_here>

[webasg]
aws_access_key_id = <access_key_here>
aws_secret_access_key = <secret_access_key_here>
EOF

ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
eval aws ec2 create-tags --resources $ID --tags 'Key=Name,Value=web-swarm-asg-$IP' --profile webasg

aws ecr get-login --no-include-email | sh

docker pull $(docker -H tcp://<swarm_endpoint_here>:2375 service ps --format "{{.Image}}" haproxy | awk 'NR==1{print $1}')
docker pull $(docker -H tcp://<swarm_endpoint_here>:2375 service ps --format "{{.Image}}" web_app | awk 'NR==1{print $1}')

adduser --disabled-password --home /home/<user_here> --gecos "" <user_here>
usermod -aG sudo <user_here>
mkdir -p /home/<user_here>/.ssh

cat << 'EOF' > /home/<user_here>/.ssh/authorized_keys
<ssh_rsa_pub_here>
EOF

chown -R <user_here>:<user_here> /home/<user_here>

echo '<user_here> ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/99_sudo_users