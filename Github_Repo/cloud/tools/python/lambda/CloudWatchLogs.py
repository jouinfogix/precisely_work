from __future__ import print_function
import json
import logging
import datetime
import base64
import gzip
import StringIO
import boto3

# AWS Varibales
awsFailedConsoleLogin = "Failure"
PROD_TOPICARN = 'arn:aws:sns:us-west-2:643933907203:CW_Alarms'

# Infogix Product Variables
productPatternStr = "/infogix/security"
failedLogin	= "FailedLogin"
groupAddedUser = "GroupAddedUser"
groupRemovedUser = "GroupRemovedUser"
userCreated = "UserCreated"
deleteUser = "deleteUser"
accountLocked = "AccountLocked"
accountUnlocked = "AccountUnlocked"

# System Variables
SUB_STR = "Authentication Failure"
failedSSH = "sshd"
invalidSSHUser = "invalid user"
failedSSHPassword = "Failed password"
nsfServerPatternStr = "/var/log/messages"
authenticationErrorPatternStr = "/var/log/secure"


logger = logging.getLogger()
logger.setLevel(logging.INFO)

def sendListsToSNS(topic, session, email_topic, email_subject, to_be_sent_list):
    session.client('sns').publish(
    TopicArn=''.join(topic),
    Subject=email_subject,
    Message=json.dumps(to_be_sent_list)
)

def lambda_handler(event, context):
    print("Recieved event: " + json.dumps(event, indent=2))
    
    # Timestamp Var
    now = datetime.datetime.utcnow()
    
    try:
        base64_message = event['awslogs']['data']
        decoded_message = base64.b64decode(base64_message)
        string_io = StringIO.StringIO(decoded_message)
        gzip_file = gzip.GzipFile(fileobj=string_io)
        cloudwatch_data = json.loads(gzip_file.read())
        
        print("Authentication Failure in: " + cloudwatch_data['logStream'])
        print("At: ", now.strftime("%Y-%m-%d %A %H:%M:%S"))
        
        # Print out CloudWatch events
        events = cloudwatch_data['logEvents']
        # sep_events = events.split(" ")[2]
        print(len(events))
        publish_session = boto3.Session()
        for i in range(len(events)):
            print(events[i])
        log_messages = "Attention: " + cloudwatch_data['logStream'] + " " + cloudwatch_data['logGroup'] + " Entry: "
        for message in cloudwatch_data['logEvents']:
            log_messages = log_messages + message['message']
        
        # SNS email
        
        if nsfServerPatternStr in log_messages:
            SUB_STR = "nfs server problem in environment: " + cloudwatch_data['logStream']
        elif productPatternStr in log_messages:
			stripDot = message['message'].split(' ')[-1].split('.')[0]
		
			if groupRemovedUser in log_messages:
				SUB_STR = "Account '" + message['message'].split(' ')[-4] + "' has been removed from group '" + stripDot + "' in environment: " + cloudwatch_data['logStream']
			elif groupAddedUser in log_messages:
				SUB_STR = "Account '" + message['message'].split(' ')[-4] + "' has been added to group " + "'" + stripDot + "'" + " in environment: " + cloudwatch_data['logStream']
			elif accountLocked in log_messages:
				SUB_STR = "Account '" + message['message'].split(' ')[-4] + "' has been locked in environment: " + cloudwatch_data['logStream']
			elif accountUnlocked in log_messages:
				SUB_STR = "Account '" + message['message'].split(' ')[-3] + "' has been unlocked in environment: " + cloudwatch_data['logStream']
			elif failedLogin in log_messages:
				SUB_STR = "Failed Product login by user '" + message['message'].split(' ')[-4] + "' in environment: " + cloudwatch_data['logStream']
			elif userCreated in log_messages:
				SUB_STR = "Account '" + stripDot + "' has been created in environment: " + cloudwatch_data['logStream']
			elif deleteUser in log_messages:
				SUB_STR = "An account has been deleted from environment: " + cloudwatch_data['logStream']
			else:
				SUB_STR = "Generic entry in Product Audit Log Messages"
        elif failedSSH in log_messages:
			if invalidSSHUser in log_messages:
				SUB_STR = "Failed SSH login by invalid user " + message['message'].split(' ')[-6] + " from " + message['message'].split(' ')[-4] + " in " + cloudwatch_data['logStream']
			else:
				SUB_STR = "Failed SSH login by " + message['message'].split(' ')[-6] + " from " + message['message'].split(' ')[-4] + " in " + cloudwatch_data['logStream']
        else:
			if awsFailedConsoleLogin in log_messages:
				#SUB_STR = "Failure in awsFailedConsoleLogin"
				SUB_STR = "AWS Console Sign-in failure: " + message['message'].split(',')[5].split(':')[1].split('}')[0] + " Source IP: " + message['message'].split(',')[10].split(':')[1]
			else:
				SUB_STR = "Generic entry in awsFailedConsoleLogin"
        
        SUB_STR = SUB_STR[:99]
		#println (SUB_STR)        
        sendListsToSNS(PROD_TOPICARN, publish_session, SUB_STR, SUB_STR, log_messages)
        #sendListsToSNS(PROD_TOPICARN, publish_session, "Authentication Failure", "Authentication Failure", cloudwatch_data)
    except Exception as err:
        logger.error("Failed to get CloudWatch Events with error {}!".format(err))