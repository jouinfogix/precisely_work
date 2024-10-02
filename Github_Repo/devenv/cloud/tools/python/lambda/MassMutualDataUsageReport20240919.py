import json
import os
import sys
import logging
import pyodbc
import boto3
from datetime import datetime
from base64 import b64decode

bucketname = os.environ['bucket_name']
sql_columns = "\"ServerName\",\"SchemaName\",\"TableName\",\"RowCount\",\"RowCountChange\",\"TableTotalSpaceMB\",\"TableUsedSpaceMB\",\"TableUnusedSpaceMB\",\"ServerTotalSpaceGB\",\"ServerPctFree\",\"HasRetention\",\"Min_UpdateTime\",\"DisplayDate\""

SUB_STR = "MassMuturalDataUsageReport triggered"
PROD_TOPICARN = 'arn:aws:sns:us-west-2:643933907203:Alerts'
now = datetime.utcnow()


def processSingleInstanceDataUsage(serverId, filename, driver, host, port, database, username, password):
    sql_process = "[dbo].[sp_ProcessAllDataUsage] @ServerID = "  + serverId
    sql_content = "[dbo].[sp_GetTopTableSize] @ServerID = " + serverId + ", @StartDate=NULL, @EndDate = NULL"
    row_delimiter = "\n"
    column_delimiter = ','
    column_textqualifier = '\"'
    
    result = []
    result.append(sql_columns)
    rds = RDS(driver, host, port, database, username, password)
    
    try:
        conn=pyodbc.connect(rds.connection)
        with conn.cursor() as cursor:
            cursor.execute(sql_process)
        conn.commit()

        conn=pyodbc.connect(rds.connection)
        cur = conn.cursor()
        cur.execute(sql_content)
        rows = cur.fetchall()
        for row in rows:
            result.append("\n")
            i = 0
            for col in row:
                if(i > 0):
                    result.append(column_delimiter)
                    result.append(column_textqualifier)
                    result.append(str(col))
                    result.append(column_textqualifier)
                else:
                    result.append(column_textqualifier)
                    result.append(str(col))
                    result.append(column_textqualifier)
                i = i + 1
    finally:
        conn.close()        
    #print(result)
    #return result
    file_attribute = File_Attribute(bucketname, file_postfix(), filename)
    save_string_to_s3(file_attribute, ''.join(str(x) for x in result))
    
    
def processDataUsage():
    serverIds = ['1','2','3']
    for serverId in serverIds:
        filename = os.getenv('FILENAME' + serverId)
        driver = os.getenv('DRIVER' + serverId)
        host = os.getenv('HOST' + serverId)
        port = os.getenv('PORT' + serverId)
        database = os.getenv('DATABASE' + serverId)
        username = os.getenv("USERNAME" + serverId)
        #password = os.getenv("PASSWORD" + serverId)
        password = boto3.client('kms').decrypt(CiphertextBlob=b64decode(os.environ['PASSWORD' + serverId]),EncryptionContext={'LambdaFunctionName': os.environ['AWS_LAMBDA_FUNCTION_NAME']})['Plaintext'].decode('utf-8')
        processSingleInstanceDataUsage(serverId, filename, driver, host, port, database, username, password)
        
    
def save_string_to_s3(file_attribute, result):
    s3 = boto3.resource('s3')
    object = s3.Object(file_attribute.bucketname, file_attribute.reportfilename)
    object.put(Body=result)

def file_postfix():
    return datetime.today().strftime('%Y%m%d')
    

def lambda_handler(event, context):
    processDataUsage()
    sendListsToSNS(PROD_TOPICARN, boto3.Session(), "Nightly Mass Mutual Report",  "Nightly Mass Mutual Report in S3: " + bucketname)
    return {
        'statusCode': 200,
        'body': json.dumps('Done processing DataUsage!')
    }
    
def sendListsToSNS(topic, session, email_subject, to_be_sent_list):
    session.client('sns').publish(
    TopicArn=''.join(topic),
    Subject=email_subject,
    Message=json.dumps(to_be_sent_list)
)

class RDS(object):
    username = ''
    password = ''
    host = ''
    port = ''
    driver = ''
    database = ''

    def __init__(self, driver, host, port, database, username, password):
        self.username = username
        self.password = password
        self.host = host
        self.port =port
        self.driver = driver
        self.database = database
        self.establish_connecion_string()

    def establish_connecion_string(self):
        def edit(string):
            remove = ['\t', '\n']
            for char in remove:
                string = string.replace(char, ' ')
            return string.replace('  ', '')

        self.connection = edit(f"""DRIVER={{{self.driver}}};
                    		      Server={self.host};
                                  PORT={self.port};
                    		      Database={self.database};
                    		      UID={self.username};
                    		      PWD={self.password};
                    		      ColumnEncryption=Enabled;
                    		      """
                               )
                               
class File_Attribute:
    def __init__(self, bucketname, filepostfix, reportname):
        self.bucketname = bucketname
        self.reportname = reportname
        self.reportfilename =  'MassMutualDataUsage/' + self.reportname + filepostfix + '.csv'