#!bin/bash

tar -zcvf definition-test-db-`date +"%Y-%m-%d"`.tar.gz /mnt/definition-test-db/
tar -xvf definition-test-db-`date +"%Y-%m-%d"`.tar.gz -C /db-backup --strip 1
