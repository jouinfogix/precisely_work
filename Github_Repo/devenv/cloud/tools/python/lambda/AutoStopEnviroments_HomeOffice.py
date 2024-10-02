from __future__ import print_function
import boto3
import datetime
import logging

# Debug flag
DRY_RUN=False

def lambda_handler (event, context):
    
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    ec2 = boto3.resource('ec2', region_name='us-east-1')
    
    instances = ec2.instances.filter(DryRun=DRY_RUN, Filters=[ { "Name" : "instance-state-name" , "Values": [ "running" ] } , {'Name':'tag:AutoStop', 'Values':['HomeOffice']}])
    for instance in instances:
        instance = ec2.Instance(instance.id)
        instanceName = getTagValue(instance.tags, "Name")
        logger.info("Stopping instance " + instanceName)
        instance.stop(DryRun=DRY_RUN, Force=False)
    return event['account'] 
    
    
def getTagValue(tags, tagName):
    for tag in tags:
        if tag["Key"] == tagName:
            return tag["Value"]
    return None