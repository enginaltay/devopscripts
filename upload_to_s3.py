### Upload a file to AWS S3

import boto3

#Create an S3 client

s3 = boto3.client('s3')

filename = 'replace_with_your_file'
bucket_name = 'replace_with_related_bucket_name'

# Uploads the given file using a managed uploader, which will split up large files automatically and upload parts in parallel.


s3.upload_file(filename, bucket_name, filename)
