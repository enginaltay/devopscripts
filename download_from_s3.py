### Download File From AWS S3

import boto3
import botocore

BUCKET_NAME = 'replace_with_your_bucket' 
KEY = 'replace_with_related_s3_file'

s3 = boto3.resource('s3')

try:
    s3.Bucket(BUCKET_NAME).download_file(KEY, 'objectname')
except botocore.exceptions.ClientError as e:
    if e.response['Error']['Code'] == "404":
        print("The object does not exist.")
    else:
        raise
