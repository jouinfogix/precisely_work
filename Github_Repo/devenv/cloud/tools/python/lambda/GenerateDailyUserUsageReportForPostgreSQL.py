import psycopg2
import logging
import boto3
import os
import json
from datetime import datetime
from base64 import b64decode

PROD_TOPICARN = 'arn:aws:sns:us-east-1:286226875656:CopyRDSSnapShotList'

s3_bucketname= "customuserreport.sagacity.infogix.com"

host1 = os.environ['host1']
db_name1 = os.environ['db_name1']
#user1 = os.environ['user1']
user1 = boto3.client('kms').decrypt(CiphertextBlob=b64decode(os.environ['user1']))['Plaintext']
#password1 = os.environ['password1']
password1 = boto3.client('kms').decrypt(CiphertextBlob=b64decode(os.environ['password1']))['Plaintext']

column_delimiter = ','
column_textqualifier = '\"'

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def sendListsToSNS(topic, session, email_topic, email_subject, body):
    session.client('sns').publish(
    TopicArn=''.join(topic),
    Subject=email_subject,
    Message=json.dumps(body)
)

def process_data():
    
    #Sagacity prod
    
    db_attrib = DB_Attribute(host1, db_name1, str(user1), str(password1))
    #print(db_attrib.connstr)
    column_results = []
    quries = Queries("public", "caf_profile", "", "SELECT * from caf_profile where membertype=2", column_results)
    file_attribute = File_Attribute(s3_bucketname, folder_cercreation(), 'tenants_system_prod')
    generate_report(db_attrib, quries, file_attribute)
    
    #db_attrib = DB_Attribute('igxcafepgdev.cg66cbzpohi7.us-east-1.rds.amazonaws.com', 'igxcafe', str(user1), str(password1))
    column_results = []
    quries = Queries("public", "caf_profile", "", "SELECT * FROM caf_profile", column_results)
    file_attribute = File_Attribute(s3_bucketname, folder_cercreation(), 'tenants_prod')
    generate_report(db_attrib, quries, file_attribute)
    
    #db_attrib = DB_Attribute('igxcafepgdev.cg66cbzpohi7.us-east-1.rds.amazonaws.com', 'igxcafe', str(user1), str(password1))
    column_results = []
    sql_column_filter = " AND COLUMN_NAME IN ('workid','objecttype','owningmemberid','execstarttime','execendtime','execrefstarttime','execrefendtime','execresulttype','execresultcode','execenginejobid','execstatus')"
    sql_column_list = " workid,objecttype,owningmemberid,execstarttime,execendtime,execrefstarttime,execrefendtime,execresulttype,execresultcode,execenginejobid,execstatus "
    sql_content = "SELECT " + sql_column_list + " FROM ds_1_null____executi_459779378 WHERE execenginejobid LIKE 'ssh%' OR execenginejobid LIKE 'n-ssh%'"
    quries = Queries("public", "ds_1_null____executi_459779378", sql_column_filter, sql_content, column_results)
    file_attribute = File_Attribute(s3_bucketname, folder_cercreation(), 'objExecEMRCluster_prod')
    generate_report(db_attrib, quries, file_attribute)
    
    #db_attrib = DB_Attribute('igxcafepgdev.cg66cbzpohi7.us-east-1.rds.amazonaws.com', 'igxcafe', str(user1), str(password1))
    #sql_column_filter = ""
    column_results = []
    sql_content = "SELECT " + sql_column_list + " FROM ds_1_null____executi_459779378 WHERE execenginejobid NOT LIKE 'ssh%' AND execenginejobid NOT LIKE 'n-ssh%'"
    quries = Queries("public", "ds_1_null____executi_459779378", sql_column_filter, sql_content, column_results)
    file_attribute = File_Attribute(s3_bucketname, folder_cercreation(), 'objExecDedicatedCluster_prod')
    generate_report(db_attrib, quries, file_attribute)
	
	#Environment(domain) name
    sql_column_filter = ""
    column_results = []
    column_results.append(column_textqualifier)
    column_results.append("domain")
    column_results.append(column_textqualifier)
    column_results.append(column_delimiter)
    column_results.append(column_textqualifier)
    column_results.append("devenv_name")
    column_results.append(column_textqualifier)
    column_results.append(column_delimiter)
    column_results.append(column_textqualifier)
    column_results.append("profile_name")
    column_results.append(column_textqualifier)
	
    sql_column_list = " pf.domain, dv.name AS devenv_name, pf.name AS profile_name "
    sql_content = "SELECT " + sql_column_list + " FROM caf_devenv dv INNER JOIN caf_profile pf ON dv.owningmemberfk = pf.memberfk ORDER BY pf.domain, pf.name"
    quries = Queries("public", "ds_1_null____executi_459779378", sql_column_filter, sql_content, column_results)
    file_attribute = File_Attribute(s3_bucketname, folder_cercreation(), 'environmentName_prod')
    generate_report(db_attrib, quries, file_attribute)
    
def generate_report(db_attrib, quries, file_attribute):
    connstr = db_attrib.connstr
    result = quries.column_results
    sql_columns = quries.sql_columns
    sql_content = quries.sql_content
	
    try:
        conn=psycopg2.connect(connstr)
    except:
        print("I am unable to connect to the database.")
    
    cur = conn.cursor()
    
    if(len(result) == 0):
        try:
            cur.execute(sql_columns)
        except:
            print("I can't SELECT from bar")
    
        rows = cur.fetchall()
        for row in rows:
            for col in row:
                if(len(result) > 0):
                    result.append(column_delimiter)
                    result.append(column_textqualifier)
                    result.append(str(col))
                    result.append(column_textqualifier)
                else:
                    result.append(column_textqualifier)
                    result.append(str(col))
                    result.append(column_textqualifier)
     
    try:
        cur.execute(sql_content)
    except:
        print("I can't SELECT from bar")

    rows = cur.fetchall()
    for row in rows:
        #result = result + "\n"
        result.append("\n")
        i = 0
        for col in row:
            if(i > 0):
                #result = result + column_delimiter + column_textqualifier + str(col) + column_textqualifier
                result.append(column_delimiter)
                result.append(column_textqualifier)
                result.append(str(col))
                result.append(column_textqualifier)
            else:
                #result = result + column_textqualifier + str(col) + column_textqualifier
                result.append(column_textqualifier)
                result.append(str(col))
                result.append(column_textqualifier)
            i = i + 1
        
    #print(result)
    save_string_to_s3(file_attribute, ''.join(result))

def save_string_to_s3(file_attribute, result):
    s3 = boto3.resource('s3')
    print("file_attribute.bucketname:" + file_attribute.bucketname)
    print("file_attribute.reportfilename:" + file_attribute.reportfilename)
    object = s3.Object(file_attribute.bucketname, file_attribute.reportfilename)
    object.put(Body=result)

def folder_cercreation():
    return datetime.today().strftime('%Y_%m_%d')

def lambda_handler(event, context):
    process_data()
    sendListsToSNS(PROD_TOPICARN, boto3.Session(), "Daily postgreSQL report", "Daily postgreSQL usage report(prod) in Sagacity account. ", "Daily postgreSQL usage report(prod) generated.")
    
class DB_Attribute:
    def __init__(self, host, db_name, user, password):
        self.host = host
        self.db_name = db_name
        self.user = user.replace("b'", "").replace("'", "")
        self.password = password.replace("b'", "").replace("'", "")
        self.connstr = "host='" + self.host + "' dbname='" + self.db_name + "' user='" + self.user + "' password='" + self.password + "'"
    
class Queries():
    def __init__(self, schema, table_name, column_filter_sql, sql_content, column_results):
        self.column_results = column_results
        self.sql_columns = ""
        if(len(column_results) == 0):
            self.sql_columns = "SELECT column_name FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '" + table_name + "' AND Table_schema = '" + schema + "' " + column_filter_sql

        self.sql_content = sql_content

class File_Attribute:
    def __init__(self, bucketname, filepath, reportname):
        self.bucketname = bucketname
        self.reportname = reportname
        self.reportfilename = filepath + '/' + self.reportname + '.csv'
        