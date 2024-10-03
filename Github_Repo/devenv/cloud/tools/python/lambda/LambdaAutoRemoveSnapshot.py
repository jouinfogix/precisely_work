import operator
import json
import boto3
from datetime import datetime, timedelta, tzinfo

Target_Region = 'us-east-2'

class Zone(tzinfo):
    def __init__(self,offset,isdst,name):
        self.offset = offset
        self.isdst = isdst
        self.name = name
    def utcoffset(self, dt):
        return timedelta(hours=self.offset) + self.dst(dt)
    def dst(self, dt):
        return timedelta(hours=1) if self.isdst else timedelta(0)
    def tzname(self,dt):
        return self.name

UTC = Zone(10,False,'UTC')

# Setting retention days
retentionDate = datetime.now(UTC) - timedelta(days=2)

def remove_old_snapshots():
    print("Connecting to RDS")
    rds = boto3.setup_default_session(region_name=Target_Region)
    client = boto3.client('rds')
    snapshots = client.describe_db_snapshots(SnapshotType='manual')
    print('Deleting all DB Snapshots older than %s' % retentionDate)

    for i in snapshots['DBSnapshots']:
        #print ('SnapshotCreateTime: ' + str(i['SnapshotCreateTime']))
        if ('SnapshotCreateTime' in i) and i['SnapshotCreateTime'] < retentionDate:
            print ('Deleting snapshot %s' % i['DBSnapshotIdentifier'])
            client.delete_db_snapshot(DBSnapshotIdentifier=i['DBSnapshotIdentifier']
        )

def lambda_handler(event, context):
    remove_old_snapshots() 