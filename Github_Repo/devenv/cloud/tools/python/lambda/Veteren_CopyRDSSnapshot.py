import boto3
import operator
import logging
import datetime
import json

ACCOUNT = '584774281607'
KmsKey = 'arn:aws:kms:us-west-1:584774281607:key/f87d7c7a-be6c-4c2f-88f5-9b7010e8f648'
Source_Region = 'us-east-1'
Target_Region = 'us-west-1'
Max_Copy_Count = 5

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SUB_STR = "CopyRDSSnapShotList triggered"
PROD_TOPICARN = 'arn:aws:sns:us-east-1:584774281607:CopyRDSSnapShotList'
now = datetime.datetime.utcnow()

def sendListsToSNS(topic, session, email_topic, email_subject, to_be_sent_list):
    session.client('sns').publish(
    TopicArn=''.join(topic),
    Subject=email_subject,
    Message=json.dumps(to_be_sent_list)
)

def copy_latest_snapshot():
    mKmsKey = ""
    copiedList = []
    loopCount = 0
    client = boto3.client('rds', Source_Region)
    destination_client = boto3.client('rds', Target_Region)
    
    response = client.describe_db_snapshots(
        SnapshotType='automated',
        IncludeShared=False,
        IncludePublic=False
    )
    
    if len(response['DBSnapshots']) == 0:
        raise Exception("No automated snapshots found")
        
    snapshots_per_project = {}
    for snapshot in response['DBSnapshots']:
        if snapshot['Status'] != 'available':
            continue
        if snapshot['DBInstanceIdentifier'] not in snapshots_per_project.keys():
            snapshots_per_project[snapshot['DBInstanceIdentifier']] = {}
        
        snapshots_per_project[snapshot['DBInstanceIdentifier']][snapshot['DBSnapshotIdentifier']] = snapshot['SnapshotCreateTime']
        
    print('snapshots_per_project.len: ' + str(len(snapshots_per_project)))    
    
    for project in snapshots_per_project:
        mKmsKey = KmsKey
        if loopCount >= Max_Copy_Count:
            continue
        
        sorted_list = sorted(snapshots_per_project[project].items(), key=operator.itemgetter(1), reverse=True)
        copy_name = project + "-" + sorted_list[0][1].strftime("%Y-%m-%d")
        print("Checking if " + copy_name + " is copied")
        
        try:
            myresponse = destination_client.describe_db_snapshots(DBSnapshotIdentifier=copy_name)
            #if len(myresponse['DBSnapshots']) == 0:
             #   raise Exception("DB snapshot " + copy_name + "does not exists in destination region yet.")
        except:
            response = destination_client.copy_db_snapshot(
                SourceDBSnapshotIdentifier='arn:aws:rds:' + Source_Region + ':' + ACCOUNT + ':snapshot:' + sorted_list[0][0],
                TargetDBSnapshotIdentifier=copy_name,
                KmsKeyId=mKmsKey,
                SourceRegion=Source_Region,
                CopyTags=True
            )
            loopCount = loopCount + 1
            
            if response['DBSnapshot']['Status'] != "pending" and response['DBSnapshot']['Status'] != "available":
                raise Exception("Copy operation for " + copy_name + " failed!")
            copiedList.append(sorted_list[0][0])
            print('Copied' + copy_name)
            
            continue
        print(copy_name + " already copied")
        
    if loopCount > 0:
        nameList = ""
        for istr in copiedList:
            nameList = nameList + istr + ";"
            
        sendListsToSNS(PROD_TOPICARN, boto3.Session(), "Nightly RDS Snapshot Copy in account: " + ACCOUNT, "Nightly RDS Snapshot Copy in account: " + ACCOUNT, str(loopCount) + " snapshots been copied." + nameList)
        
        
        
    print('copy_latest_snapshot() done.')
    
    
    
def lambda_handler(event, context):
    copy_latest_snapshot()
    return 'lambda_handler() done.'
