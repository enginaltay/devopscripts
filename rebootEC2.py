import boto3, json, time

elb_client = boto3.client('elbv2')
ec2_client = boto3.client('ec2')

def lambda_handler(event, context):
    sleep = event["sleep"]
    instances = event["instances"]
    targets = event["targets"]

    for instance in instances:
        for target in targets:
            print "Deregister ELB ","instance ",instance," target ",target
            deregister_response = elb_client.deregister_targets(
                TargetGroupArn=target["group"],
                Targets=[
                    {
                        'Id': instance,
                        'Port': target["port"],
                    }
                ]
            )
            print "response ",deregister_response

    print "sleep ",sleep
    time.sleep(sleep)

    print "reboot ",instances
    response = ec2_client.reboot_instances(
        InstanceIds=instances,
        DryRun=False
    )
    
    time.sleep(sleep)
    
    print "response ",response
    
    for instance in instances:
        for target in targets:
            print "Register ELB ","instance ",instance," target ",target
            register_response = elb_client.register_targets(
                TargetGroupArn=target["group"],
                Targets=[
                    {
                        'Id': instance,
                        'Port': target["port"],
                    }
                ]
            )
            print "response ",register_response

    print "Completed."
    return event
