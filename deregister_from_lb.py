import boto3, json

elb_client = boto3.client('elbv2')

def lambda_handler(event, context):
    for instance in event["instance_ids"]:
        public_deregister_response = elb_client.deregister_targets(
            TargetGroupArn='<target_group_arn_here>',
            Targets=[
                {
                    'Id': instance,
                    'Port': 80,
                }
            ]
        )
        
        print (public_deregister_response)
        
        internal_deregister_response = elb_client.deregister_targets(
            TargetGroupArn='<target_group_arn_here>',
            Targets=[
                {
                    'Id': instance,
                    'Port': 80,
                }
            ]
        )
        
        print (internal_deregister_response)
        
    return event
