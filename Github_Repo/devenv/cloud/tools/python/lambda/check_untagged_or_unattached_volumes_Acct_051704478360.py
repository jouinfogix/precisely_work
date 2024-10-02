"""
How to run the test inside AWS Lambda service from AWS Lambda service console:
    1. make sure the Session created with profile_name=None. O.W. the profile can be not be found
    2. from Actions/Configure Test Event, using the real account number
    {
       "account": "051704478360"
    }
"""
import boto3
import logging
import json

# Debug flag
DRY_RUN = False

# production env, it is "rli_prod". O.W. it is "rli_dev"
PROFILE = 'rli_dev'

"""
  For an account ( either dev or prod account ), only one SNS TOPIC is set up for subscriptions to. The checking info messages for all volumes cross
  different regions will be published to this very one topic!
"""

DEV_TOPICARN = 'arn:aws:sns:us-east-1:051704478360:untagged_or_unattached_EBS'
PROD_TOPICARN = 'arn:aws:sns:us-west-2:643933907203:untagged_or_unattached_EBS'

# the key is profile
REGIONS = {
    'rli_dev': {'topic': DEV_TOPICARN, 'regions': ('us-east-1',)},
    'rli_prod': {'topic': PROD_TOPICARN, 'regions': ('eu-central-1', 'us-west-2', 'us-east-1')}
}

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def check_ec2instance_status(region):
    client = boto3.client('ec2')
    response = client.describe_instance_status(
        DryRun=False,
        Filters=[
            {
                'Name': 'availability-zone',
                'Values': [region],

                'Name': 'event.code',
                'Values': ['instance-reboot', 'system-reboot', 'system-maintenance', 'instance-retirement',
                           'instance-stop']
            },
        ],
        IncludeAllInstances=True
    )

    return response


def find_all_unattached_volumes(session):
    response = session.client('ec2').describe_volumes()
    unattached_volumes = []
    count_unattached = 0
    for volume in response['Volumes']:
        if len(volume['Attachments']) == 0:
            count_unattached += 1
            volume_dict = {}
            volume_dict['VolumeId'] = volume['VolumeId']
            volume_dict['VolumeType'] = volume['VolumeType']
            volume_dict['VolumeSize'] = volume['Size']
            unattached_volumes.append(volume_dict)
    return unattached_volumes


def find_all_untagged_volumes(session):
    ec2 = session.resource('ec2')
    untagged_volumes = []
    response = session.client('ec2').describe_instances(Filters=[
        {
            'Name': 'instance-state-name',
            'Values': ['running', 'stopped']
        }
    ]
    )

    for r in response['Reservations']:
        for inst in r['Instances']:
            volumes = inst['BlockDeviceMappings']
            # Iterate over instance's volume(s)
            for volume in volumes:
                volumeID = volume['Ebs']['VolumeId']
                volume2 = ec2.Volume(volumeID)
                if volume2.tags == None:
                    volume2_dict = {}
                    volume2_dict['VolumeId'] = volume2.volume_id
                    volume2_dict['VolumeType'] = volume2.volume_type
                    volume2_dict['VolumeSize'] = volume2.size
                    untagged_volumes.append(volume2_dict)
    return untagged_volumes


def get_untagged_unattached_volumes(session):
    return find_all_unattached_volumes(session), find_all_untagged_volumes(session)


def sendListsToSNS(topic, session, email_topic, email_subject, to_be_sent_list):
    session.client('sns').publish(
        TopicArn=''.join(topic),
        Subject=email_subject,
        Message=json.dumps(to_be_sent_list)
    )


def get_account_id(session):
    try:
        return session.client('iam').get_user()['User']['Arn'].split(':')[4]
    except Exception as err:
        logger.error("Failed to get account ID with error {}!".format(err))


def makeRdsArn(rds, account, region):
    dbInstanceID = rds['DBInstanceIdentifier']
    return 'arn:aws:rds:' + region + ':' + account + ':db:' + dbInstanceID


def makeUntaggedRDS(rds):
    untagged_rds_dict = {}
    untagged_rds_dict['DBName'] = rds['DBName']
    untagged_rds_dict['DBInstanceIdentifier'] = rds['DBInstanceIdentifier']
    untagged_rds_dict['EndpointAddress'] = rds['Endpoint']['Address']
    return untagged_rds_dict


def get_untagged_rds_instances(session, account, region):
    untagged_rds_instances = []
    client = session.client('rds')
    """ get the list of rds instances """
    rds_instances = client.describe_db_instances()
    dbInstances = rds_instances['DBInstances']
    for rds in dbInstances:
        rdsARN = makeRdsArn(rds, account, region)

        response = client.list_tags_for_resource(ResourceName=rdsARN)

        tagList = response['TagList']
        if tagList:
            found = False
            for tag in tagList:
                if tag['Key'] and tag['Value'] and tag['Key'] in ['CostCenterID', 'CostCategoryID'] and tag[
                    'Value'] in ['LIC', 'CLC', 'POC', 'SVC', 'DEV']:
                    found = True
                    break

            if found == False:
                untagged_rds_instances.append(makeUntaggedRDS(rds))
        else:  # no tags defined
            untagged_rds_instances.append(makeUntaggedRDS(rds))

    return untagged_rds_instances


def check_untagged_or_unattached_EBS_volumes(event, context):
    try:

        profile_regions = REGIONS[PROFILE]
        topic = profile_regions['topic']
        topic_existed_on_region = topic.split(':')[3]
        publish_session = boto3.Session(profile_name=None, region_name=topic_existed_on_region)
        regions = profile_regions['regions']

        for region in regions:

            session = boto3.Session(profile_name=None, region_name=region)
            unattached_list, untagged_list = get_untagged_unattached_volumes(session)

            if len(untagged_list) > 0:
                sendListsToSNS(topic, publish_session, "Untagged EBS Volumes",
                               "AWS Account: <{}> at region: {} has untagged resources".format(event['account'],
                                                                                               region), untagged_list)

            if len(unattached_list) > 0:
                sendListsToSNS(topic, publish_session, "Unattached EBS Volumes",
                               "AWS Account: <{}> at region: {} has unattached resources".format(event['account'],
                                                                                                 region),
                               unattached_list)

            untagged_rds_instances = get_untagged_rds_instances(session, event['account'], region)
            if len(untagged_rds_instances) > 0:
                sendListsToSNS(topic, publish_session, "Untagged RDS instances",
                               "AWS Account: <{}> at region: {} has untagged RDS instances".format(event['account'],
                                                                                                   region),
                               untagged_rds_instances)

            response = check_ec2instance_status(region)
            if response['ResponseMetadata']['HTTPStatusCode'] == 200:
                if len(response['InstanceStatuses']) > 0:
                    sendListsToSNS(topic, publish_session, "AWS Scheduled Events",
                                   "AWS Account: <{}> at region: {} has Scheduled Events".format(event['account'],
                                                                                                 region), response)

    except Exception as err:
        logger.error("Failed to get account ID with error {}!".format(err))


if __name__ == "__main__":
    check_untagged_or_unattached_EBS_volumes("TestEvent", "TestContext")
