from ftplib import FTP
from os import environ
from datetime import date, timedelta
import boto3

yesterday = date.today() - timedelta(1)
remoteFile = yesterday.strftime('NewFile_%Y%m%d.csv')
s3 = boto3.resource('s3', region_name='eu-central-1')
bucket = 'aws_bucket_name'
ftpUrl = 'ftp_address'

def lambda_handler(event, context):
    try:
        localFile = open('/tmp/' + remoteFile, 'wb')
        print ('Generated empty file.')
        ftp = FTP(ftpUrl)
        ftp.login(environ['LoginName'], environ['LoginPass'])
        print ('Opened FTP connection.')
        ftp.retrbinary('RETR %s' % remoteFile, localFile.write)
        localFile.close()
        print ('Transfer complete.')
        s3.Object(bucket, 'bucket_folder/' + remoteFile).put(Body=open('/tmp/' + remoteFile, 'rb'))
        ftp.quit()
    except Exception as e:
        print e
