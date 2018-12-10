#!bin/bash

#Tar yesterday request log and give name within date
tar -zcvf /tmp/requestlogs/request-logs-`date --date="yesterday" +%Y-%m-%d`.tar.gz /opt/app/logs/requests.log.`date --date="yesterday" +%Y-%m-%d`

#Remove yesterday request log
rm /opt/app/logs/requests.log.`date --date="yesterday" +%Y-%m-%d`

#Upload tar file to S3
aws s3 sync /tmp/requestlogs/ s3://{bucket-name}/requestlogs/ --exclude '*' --include "*.tar.gz"