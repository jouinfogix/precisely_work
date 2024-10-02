USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[ProcessDeadLockDetail]    Script Date: 2/20/2024 5:39:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[ProcessDeadLockDetail] (
   @fileName NVARCHAR(260) = N'system_health*.xel'
   )
AS
BEGIN
DECLARE @max_timestamp_utc datetime2(7);
SELECT @max_timestamp_utc = MAX(timestamp_utc) FROM [dbo].[ad_deadlock_detail];
IF @max_timestamp_utc IS NULL
BEGIN 
	SET @max_timestamp_utc = '1900-01-01 00:00:00.0000000';
END

-- Delete data older than 60 days
DELETE FROM [dbo].[ad_deadlock_detail] 
WHERE timestamp_utc < DATEADD(day, -60, GETDATE())

INSERT INTO [dbo].[ad_deadlock_detail]
(
timestamp_utc
,victimProcessid 
,processid
,transactionname
,lasttranstarted
,lockMode
,[status] 
,spid
,clientapp
,hostname
,loginname 
,currentdbname 
,lockTimeout
,keylock_objectname
,inputbuf)

SELECT DISTINCT
    s.timestamp_utc AS timestamp_utc,
    m.c.value('@id', 'varchar(200)') as victimProcessid
    ,Y.ID.value('@id', 'varchar(100)') as "processid"
   ,Y.ID.value('@transactionname', 'varchar(100)') as "transactionname"
   ,Y.ID.value('@lasttranstarted', 'varchar(100)') as "lasttranstarted"
   ,Y.ID.value('@lockMode', 'varchar(50)') as "lockMode"
    ,Y.ID.value('@status', 'varchar(100)') as "status"
   ,Y.ID.value('@spid', 'int') as "spid"
    ,Y.ID.value('@clientapp', 'varchar(100)') as "clientapp"
   ,Y.ID.value('@hostname', 'varchar(100)') as "hostname"
   ,Y.ID.value('@loginname', 'varchar(50)') as "loginname"
   ,Y.ID.value('@currentdbname', 'varchar(50)') as "currentdbname"
   ,Y.ID.value('@lockTimeout', 'bigint') as "lockTimeout"
   ,X.S.value('@objectname', 'varchar(200)') as keylock_objectname
   ,Y.ID.value('inputbuf[1]', 'varchar(2000)') as inputbuf
FROM 
   (SELECT CONVERT(XML, event_data) AS event_data,timestamp_utc, [object_name] 
      FROM sys.fn_xe_file_target_read_file(@fileName,null,null,null))  as s
    outer apply s.event_data.nodes('/event/data/value/deadlock/victim-list/victimProcess') as m(c)
	outer apply s.event_data.nodes('/event/data/value/deadlock/process-list/process') as Y(ID)
	outer apply s.event_data.nodes('/event/data/value/deadlock/resource-list/keylock') as X(S)
WHERE  s.[object_name] = 'xml_deadlock_report'
AND CAST(s.timestamp_utc AS datetime2(7)) > @max_timestamp_utc;

END;
GO


