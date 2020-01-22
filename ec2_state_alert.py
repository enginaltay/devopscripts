import json
import boto3
import datetime
import dateutil.tz
from collections import defaultdict

def lambda_handler(event, context):

    #Connect to EC2 resource
    ec2 = boto3.resource('ec2')
    ec2_client = boto3.client('ec2')
    sns_client = boto3.client('sns', region_name='eu-central-1')

    coming_from_cloudwatch = event["instances"]
    
    #filter the running instances based on instance state 
    stopped_instances = ec2.instances.filter(
      Filters = [{
        'Name': 'instance-state-name',
        'Values': ['stopped']
      }])
    
    #Create a empty dict
    ec2_info = defaultdict()
    #Set local timezone
    local_tz = dateutil.tz.gettz('Europe/Istanbul')
    #Set initial sendMail action false
    sendMail = False
    
    #Compare stopped instances in aws account and given cloudwatch instance ids
    for instance in stopped_instances:
        for cld in coming_from_cloudwatch:
            for tag in instance.tags:
                if 'Name' in tag['Key']:
                    name = tag['Value']
            if cld == instance.id:
                local_dt = instance.launch_time.astimezone(local_tz)
                sendMail = True
                ec2_info[instance.id] = {
                  'State': instance.state['Name'],
                  'Server': name,
                  'Private IP': instance.private_ip_address,
                  'Last Launch Time': local_dt.strftime("%Y-%m-%d %H:%M:%S")
        }
        
    print (ec2_info) 
    
    response = ec2_info
    
    #Send Mail if sendMail action true
    if sendMail:
        response = sns_client.publish(
        TargetArn='your_sns_arn',
        Message=json.dumps({'default': json.dumps(response)}),
        Subject='Alert! Unexpected EC2 state is detected. Check the AWS Console.',
        MessageStructure='json'
    )
                  
    

         
