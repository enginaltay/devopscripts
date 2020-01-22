#!bin/bash

BUCKET=<BUCKET_NAME_HERE>
FOLDER=<FOLDER_NAME_HERE>
FILE=<FILE_NAME_HERE>

#Tar db folder
tar -zcvf /opt/mongo-backup/<FOLDER_NAME>-`date +"%Y-%m-%d"`.tar.gz /mnt/db/
#Upload tar db file to S3 bucket
/usr/local/bin/aws s3 sync /opt/mongo-backup/ s3://<BUCKET_NAME>/db-backup/

sleep 3

#Check whether you successfully uploaded your db backup
aws s3 ls s3://$BUCKET/$FOLDER/ | awk 'END{print}' | awk '{print $NF}' >> is_db_exists.txt
isFileExists=$(cat is_db_exists.txt | awk 'END{print}' | awk '{print $NF}')
if [[ $isFileExists = *$FILE-`date +"%Y-%m-%d"`.tar.gz ]]; then
    echo "File uploaded successfully." >> is_db_uploaded.txt
else
    echo "Something Wrong. Please check your S3 bucket : $BUCKET" >> is_db_uploaded.txt
fi

#-------------------Restore From Backup Scenerio To Do List--------------------------#
#download latest backup folder from s3
/usr/local/bin/aws s3 cp s3://<BUCKET_NAME/db-backup/<FOLDER_NAME>-`date +"%Y-%m-%d"`.tar.gz  /opt/mongo-backup/ 

#untar db to backup folder if you already have latest backup in host folder
tar -xvf <FILE_NAME_HERE>-`date +"%Y-%m-%d"`.tar.gz -C /opt/mongo-backup --strip 1 



