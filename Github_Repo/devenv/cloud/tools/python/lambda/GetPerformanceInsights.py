import json
import boto3
import os
from datetime import datetime

# Initialize boto3 clients
pi_client = boto3.client('pi')
s3_client = boto3.client('s3')

# Change the following statments to get result
start_time = '2024-09-30T08:00:00Z'
end_time = '2024-09-30T17:00:00Z'

#Please note we must use ResourceID get from AWS RDS console configuration tag. Can not use DB identity!
db_identifier = 'db-YGDYB5H6M7CPJ35LBQ2H2G4YRU'

metric = 'db.load.avg'

aws_region = 'us-east-1'
period_in_seconds = 60

report_name = 'pi_metrics'

s3_bucket = 'ew-engineering11-prod'
s3_path = 'PerformanceInsightsReport'

temp_file = '/tmp/report.json'


def processPerInsightData():
    #print('here')
    # Retrieve Performance Insights data
    response = pi_client.get_resource_metrics(
        ServiceType='RDS',
        Identifier=db_identifier,
        MetricQueries=[
            {
                'Metric': metric,
                'GroupBy': {
                    'Group': 'db.sql', 
                    'Dimensions': ['db.sql.id','db.sql.statement']
                }
                
            }
        ],
        StartTime=datetime.strptime(start_time, '%Y-%m-%dT%H:%M:%SZ'),
        EndTime=datetime.strptime(end_time, '%Y-%m-%dT%H:%M:%SZ'),
        PeriodInSeconds=period_in_seconds
    )
    
    json_data = json.dumps(response, cls=DateTimeEncoder)
    
    # Save the JSON data to the temporary file
    with open(temp_file, 'w') as json_file:
        json_file.write(json_data)
        
    s3_key = s3_path + '/' + report_name + file_postfix() + '.json'
    # Upload the CSV file to S3
    s3_client.upload_file(temp_file, s3_bucket, s3_key)
    

def lambda_handler(event, context):
    processPerInsightData()
    return {
        'statusCode': 200,
        'body': json.dumps('RDS Performance Insights Lambda!')
    }
    
def file_postfix():
    return datetime.today().strftime('%Y%m%d_%H%M')
    
# Custom encoder to handle datetime objects
class DateTimeEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.isoformat()  # Convert datetime to ISO format string
        return super(DateTimeEncoder, self).default(obj)