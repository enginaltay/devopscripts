#!bin/bash

tar -zcvf test-db-`date +"%Y-%m-%d"`.tar.gz /mnt/test-db/ #Tar db folder
tar -xvf test-db-`date +"%Y-%m-%d"`.tar.gz -C /db-backup --strip 1 #untar db to backup folder
