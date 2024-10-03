import threading
import json
import os
import boto3
from boto3.dynamodb.conditions import Key

#Table_Name = "produk___ExecutionHistoryDetails2___"
Table_Name = os.environ['table_name']
Region_Name = os.environ['region_name']
LoopCountLimit = os.environ['loop_count_limit']
TotalThreads = os.environ['total_threads']
RecordsetLimit = 99
BatchSize = 25

def delete_item(dynamodb_client, results, IdList):
    if( not IdList or len(IdList)==0):
        return
    #print("-----")
    #for id in IdList:
    #    print(id)
    #results[0] = results[0] + len(IdList)
        
    #session = boto3.session.Session(region_name=Region_Name)
    #dynamodb_client = session.client('dynamodb')
    
    #deleterequestarray = [0]*len(IdList)
    
    Request_Items={
        'tableName': [
            {
                    'DeleteRequest': {
                        'Key': {
    			            "WorkId": {"S": "3262449qwe66"},
    			            "Id": {"S": "201413t202"}
    			        }
    		    }
            }
        ]
    }


    Request_Items[Table_Name] = Request_Items['tableName']
    del Request_Items['tableName']
    #for i,item in enumerate(Request_Items[Table_Name]):
    #    item['DeleteRequest']['Key']['WorkId']['S']=Work_Id
    #    item['DeleteRequest']['Key']['Id']['S']=IdList[i]
  
    Request_Items[Table_Name].clear()
       
    for item in IdList:
        Request_Items[Table_Name].append({'DeleteRequest': {'Key': {'WorkId' : {'S' : item['WorkId']['S']}, 'Id' : {'S' : item['Id']['S']}}}})
        results[0] = results[0] + 1
    
    #if(results[0] < 100):
    #    print("results[0]=")
    #    print(str(results[0]))
    #    print("Request_Items=")
    #    print(Request_Items)
    #return    
    
    response = dynamodb_client.batch_write_item(
        RequestItems=Request_Items
    )

        
def process_resultset(dynamodb_client, results, result_data):
    if( not result_data or len(result_data["Items"])==0):
        return
    #print( result_data["Items"])
    
    IdList = []
    loopCount = 0
    for item in result_data["Items"]:
        IdList.append(item)
        loopCount = loopCount + 1
        if((loopCount+1) > BatchSize):
            loopCount = 0
            delete_item(dynamodb_client, results, IdList)
            IdList.clear()

    delete_item(dynamodb_client, results, IdList)       
    

def scan_table(segment, total_segments, results, workidList):
    session = boto3.session.Session(region_name=Region_Name)
    dynamodb_client = session.client('dynamodb')
    session_delete = boto3.session.Session(region_name=Region_Name)
    dynamodb_client_delete = session_delete.client('dynamodb')
    
    #filter_expression = "WorkId = :work_id"
    
    expression_attributeValues = {
        ':work_id0': {'S': ''}
    }
    
    filter_expression = "WorkId IN ("
    
    i = 0
    for workid in workidList:
        token = ""
        token = " :work_id" + str(i)
        if (i > 0):
            token = "," + token 
        filter_expression = filter_expression + token
        expression_attributeValues[':work_id' + str(i)] = {'S' : workid}
        i = i + 1
    
    filter_expression = filter_expression + ")"
    
    #print("filter_expression:")
    #print(filter_expression)
    #print("")
    #print("expression_attributeValues:")
    #print(expression_attributeValues)
    #return
    
    projection_expression="WorkId, #mID"
    expression_attributeNames = {"#mID": "Id"}
   
    result_data = dynamodb_client.scan(
        TableName = Table_Name,
        FilterExpression=filter_expression,
        ExpressionAttributeValues = expression_attributeValues,
        ProjectionExpression = projection_expression,
        ExpressionAttributeNames = expression_attributeNames,
        Limit=RecordsetLimit,
        ConsistentRead=True,
        Segment=segment,
        TotalSegments=total_segments
    )
    
    #print('print results:')
    #print(result_data["Items"])
    #print(result_data["Items"][0]["Id"]["S"])
    process_resultset(dynamodb_client_delete, results, result_data)

    LoopCount = 0
    # while 'LastEvaluatedKey' in result_data:
    LoopLimit = int(LoopCountLimit)
    while 'LastEvaluatedKey' in result_data:
    #while LoopCount < LoopLimit and 'LastEvaluatedKey' in result_data:
        result_data = dynamodb_client.scan(
            TableName = Table_Name,
            FilterExpression=filter_expression,
            ExpressionAttributeValues = expression_attributeValues,
            ProjectionExpression = projection_expression,
            ExpressionAttributeNames = expression_attributeNames,
            ExclusiveStartKey=result_data['LastEvaluatedKey'],
            Limit=RecordsetLimit,
            ConsistentRead=True,
            Segment=segment,
            TotalSegments=total_segments
        )
        process_resultset(dynamodb_client_delete, results, result_data)
        LoopCount = LoopCount + 1
    #print("LoopLimit=" + str(LoopLimit))        
    #print("workid=" + workid)

def create_threads(workidList):
    totalItem_count = 0
    results = [None] * 10
    results[0]=0
    thread_list = []
    total_threads = int(TotalThreads)
    for i in range(total_threads):
        # instantiate and store the thread
        thread = threading.Thread(target=scan_table, args=(i, total_threads, results, workidList))
        thread_list.append(thread)
    # Start threads
    for thread in thread_list:
        thread.start()
    # Block main thread until all threads are finished
    for thread in thread_list:
        thread.join()
        totalItem_count = totalItem_count + int(str(results[0]))
    
    print("totalItem_count=" + str(totalItem_count))
    
def lambda_handler(event, context):
    #workidList = ['f990b4d2aa6f4ef699f4321e51b505ae','140150daf57d4f1093b0f02ab11a4621','67ec8663c9e64839808de76f8fb3da00','79ef6a4c08aa48eebc1a9d5d8a58c4d0','3955c0c4cdac49c2a1894de3063e2b00','35a5512c4931499cb0e1e29b2efb9fa1','9b4d8d5b3ddf4999a5b56012f35496aa','01ae87a9d9714b08b9b968ca7fc8ae13','8516c7735fb74804860ecfe3f3201d7d','60720d850b9c4597ad9593d51d45c3db','8794e4022e46460c97645e1b01289ef1','f463c136b764414f8bac8f840438395c']
    #workidList = ['01ae87a9d9714b08b9b968ca7fc8ae13','8516c7735fb74804860ecfe3f3201d7d','60720d850b9c4597ad9593d51d45c3db','8794e4022e46460c97645e1b01289ef1','f463c136b764414f8bac8f840438395c']
    #workidList = ['140150daf57d4f1093b0f02ab11a4621','67ec8663c9e64839808de76f8fb3da00','79ef6a4c08aa48eebc1a9d5d8a58c4d0','3955c0c4cdac49c2a1894de3063e2b00','35a5512c4931499cb0e1e29b2efb9fa1','9b4d8d5b3ddf4999a5b56012f35496aa']
    #workidList = ['79ef6a4c08aa48eebc1a9d5d8a58c4d0','9b4d8d5b3ddf4999a5b56012f35496aa','8516c7735fb74804860ecfe3f3201d7d']
    #workidList = ['79ef6a4c08aa48eebc1a9d5d8a58c4d0','8516c7735fb74804860ecfe3f3201d7d']
    workidList = ['8516c7735fb74804860ecfe3f3201d7d']

    create_threads(workidList)
    


    

    