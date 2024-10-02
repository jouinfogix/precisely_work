import boto3
import operator
import logging
import datetime
import json

ACCOUNT = '643933907203'
KmsKey = 'arn:aws:kms:us-east-2:643933907203:key/43b6d03a-46d7-421f-ade3-656ed972a573'
KmsKey_Second = 'arn:aws:kms:us-east-1:643933907203:key/d39d8b03-08ee-470f-acde-bbe452c17e8e'

Source_Region = 'us-west-2' #Oregon
Target_Region = 'us-east-2' #Ohio
Target_Region_Second = 'us-east-1' #Virginia. Must have seond region. One region is not fast enough to copy all the snapshots.
Max_Copy_Count = 5

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SUB_STR = "CopyRDSSnapShotList triggered"
PROD_TOPICARN = 'arn:aws:sns:us-west-2:643933907203:Alerts'
now = datetime.datetime.utcnow()

def sendListsToSNS(topic, session, email_topic, email_subject, to_be_sent_list):
    session.client('sns').publish(
    TopicArn=''.join(topic),
    Subject=email_subject,
    Message=json.dumps(to_be_sent_list)
)

def copy_instance_snapshot():
    totalLoopCount = 0
    copiedList = []
    
    client = boto3.client('rds', Source_Region)
    response_instance = client.describe_db_instances(
        MaxRecords=100
    )
    if len(response_instance['DBInstances']) == 0:
        raise Exception("No DBInstanceIdentifier found")
    for instance in response_instance['DBInstances']:
        item = ""
        if totalLoopCount >= Max_Copy_Count:
            continue
        print('instance:' + instance['DBInstanceIdentifier'])
        try:
            item = copy_latest_snapshot(instance['DBInstanceIdentifier'])
        except Exception as inst:
            print(inst)
            
        if len(item) > 0:
            copiedList.append(item)
            totalLoopCount = totalLoopCount + 1
    
    listCount = len(copiedList)
    if listCount > 0:
        nameList = ""
        for istr in copiedList:
            nameList = nameList + istr + ";"
        
        sendListsToSNS(PROD_TOPICARN, boto3.Session(), "Nightly RDS Snapshot Copy in account: " + ACCOUNT, "Nightly RDS Snapshot Copy in account: " + ACCOUNT, str(listCount) + " snapshots been copied." + nameList)
    
        
def copy_latest_snapshot(DBInstanceIdentifier):
    loopCount = 0
    sendEmailAlready = False
    copiedList = ""
    client = boto3.client('rds', Source_Region)
    mTarget_Region = Target_Region
    mKmsKey = KmsKey
    if DBInstanceIdentifier.find('test') >= 0:
        mTarget_Region = Target_Region_Second
        mKmsKey = KmsKey_Second
        
    destination_client = boto3.client('rds', mTarget_Region)

    response = client.describe_db_snapshots(
        SnapshotType='automated',
        DBInstanceIdentifier=DBInstanceIdentifier,
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

        snapshots_per_project[snapshot['DBInstanceIdentifier']][snapshot['DBSnapshotIdentifier']] = snapshot[
            'SnapshotCreateTime']

    #print('snapshots_per_project.len: ' + str(len(snapshots_per_project)))
    
    for project in snapshots_per_project:
       #print('loopCount: ' + str(loopCount))
        if loopCount >= Max_Copy_Count - 1 :
            continue
        sorted_list = sorted(snapshots_per_project[project].items(), key=operator.itemgetter(1), reverse=True)

        copy_name = project + "-" + sorted_list[0][1].strftime("%Y-%m-%d")

        print("Checking if " + copy_name + " is copied")

        try:
            destination_client.describe_db_snapshots(
                DBSnapshotIdentifier=copy_name
            )
        except:
            response = destination_client.copy_db_snapshot(
                SourceDBSnapshotIdentifier='arn:aws:rds:' + Source_Region + ':' + ACCOUNT + ':snapshot:' + sorted_list[0][0],
                TargetDBSnapshotIdentifier=copy_name,
                KmsKeyId=mKmsKey,
                SourceRegion=Source_Region,
                CopyTags=True
            )
            loopCount = loopCount + 1
            copiedList = copiedList + sorted_list[0][0]
            
            if ('DBSnapshot' in response) and response['DBSnapshot']['Status'] != "pending" and response['DBSnapshot']['Status'] != "available":
               # if loopCount > 0 and sendEmailAlready == False:
                #    sendListsToSNS(PROD_TOPICARN, boto3.Session(), "Nightly RDS Snapshot Copy in account: " + ACCOUNT, "Nightly RDS Snapshot Copy in account: " + ACCOUNT, str(loopCount) + " snapshots been copied." + copiedList)
               #     sendEmailAlready = True
                raise Exception("Copy operation for " + copy_name + " failed!")
            print("Copied " + copy_name)

            continue

        print(copy_name + " already copied")
        
    #if loopCount > 0 and sendEmailAlready == False:
    #    sendListsToSNS(PROD_TOPICARN, boto3.Session(), "Nightly RDS Snapshot Copy in account: " + ACCOUNT, "Nightly RDS Snapshot Copy in account: " + ACCOUNT, str(loopCount) + " snapshots been copied." + copiedList)
    
    return copiedList

def lambda_handler(event, context):
    copy_instance_snapshot()
    #copy_latest_snapshot()

if __name__ == '__main__':
    lambda_handler(None, None)