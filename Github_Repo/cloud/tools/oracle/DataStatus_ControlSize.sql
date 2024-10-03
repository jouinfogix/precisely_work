

BEGIN
DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'CONTROLDATA');
END;
/

BEGIN
dbms_scheduler.create_job(job_name => 'CONTROLDATA',
job_type => 'PLSQL_BLOCK',
job_action => '
BEGIN
DECLARE 
DBNAME NVARCHAR2(10);
DATETIMESTR NVARCHAR2(50);
CSR_COUNT NVARCHAR2(50);
HMBR_COUNT NVARCHAR2(50);

v_file_handle utl_file.file_type;
OUTPUT NVARCHAR2(2000);
BEGIN
SELECT NAME INTO DBNAME FROM V$DATABASE;
SELECT CAST(SYSTIMESTAMP AS NVARCHAR2(50)) INTO DATETIMESTR FROM DUAL;

WITH CTE_ALL AS(
SELECT
   X.TABLE_NAME AS TABLE_NAME, X.bytes/1024/1024/1024 AS BytesInGB
FROM
(SELECT segment_name table_name, owner, bytes
FROM dba_segments
WHERE segment_type in  (''TABLE'',''TABLE PARTITION'')
UNION ALL
SELECT i.table_name, i.owner, s.bytes
FROM dba_indexes i, dba_segments s
WHERE s.segment_name = i.index_name
AND   s.owner = i.owner
AND   s.segment_type in (''INDEX'',''INDEX PARTITION'')
UNION ALL
SELECT l.table_name, l.owner, s.bytes
FROM dba_lobs l, dba_segments s
WHERE s.segment_name = l.segment_name
AND   s.owner = l.owner
AND   s.segment_type IN (''LOBSEGMENT'',''LOB PARTITION'')
UNION ALL
SELECT l.table_name, l.owner, s.bytes
FROM dba_lobs l, dba_segments s
WHERE s.segment_name = l.index_name
AND   s.owner = l.owner
AND   s.segment_type = ''LOBINDEX'') X
WHERE EXISTS(SELECT T.table_name, T.tablespace_name FROM dba_tables T 
             WHERE T.table_name = X.table_name AND T.owner = X.owner
                   AND T.owner=''IAUSER'')),
CTE_HM AS (
 SELECT TRUNC(SUM(CTE_ALL.BytesInGB)) AS SizeGB 
 FROM CTE_ALL CTE_ALL 
 WHERE CTE_ALL.TABLE_NAME LIKE ''UP/_%HM/_%'' ESCAPE ''/'' AND
       CTE_ALL.TABLE_NAME NOT LIKE ''UP/_%HM1/_%'' ESCAPE ''/'' AND
       CTE_ALL.TABLE_NAME NOT LIKE ''UP/_%HMBR/_%'' ESCAPE ''/'' 
),
CTE_HM1 AS (
 SELECT TRUNC(SUM(CTE_ALL.BytesInGB)) AS SizeGB 
 FROM CTE_ALL CTE_ALL 
 WHERE CTE_ALL.TABLE_NAME LIKE ''UP/_%HM1/_%'' ESCAPE ''/''
),
CTE_MHS AS (
 SELECT TRUNC(SUM(CTE_ALL.BytesInGB)) AS SizeGB 
 FROM CTE_ALL CTE_ALL 
 WHERE CTE_ALL.TABLE_NAME LIKE ''UP/_%MHS/_%'' ESCAPE ''/''
),
CTE_HMBR AS (
 SELECT TRUNC(SUM(CTE_ALL.BytesInGB)) AS SizeGB 
 FROM CTE_ALL CTE_ALL 
 WHERE CTE_ALL.TABLE_NAME LIKE ''UP/_%HMBR/_%'' ESCAPE ''/''
)
SELECT NVL(HM.SizeGB, 0)  + NVL(HM1.SizeGB, 0)  + NVL(MHS.SizeGB, 0), NVL(HMBR.SizeGB, 0) INTO 
      CSR_COUNT, HMBR_COUNT
FROM CTE_HM HM, CTE_HM1 HM1, CTE_MHS MHS, CTE_HMBR HMBR;
      
v_file_handle:=utl_file.fopen(''BDUMP'',''alert_'' || DBNAME || ''.log'', ''a'');
IF(CSR_COUNT IS NOT NULL) THEN
   OUTPUT := ''CUSTOMLOG;CSR;'' || CSR_COUNT || '';'' || DATETIMESTR;
   utl_file.put_line (v_file_handle, OUTPUT);
END IF;
IF(HMBR_COUNT IS NOT NULL) THEN
   OUTPUT := ''CUSTOMLOG;HMBR;'' || HMBR_COUNT || '';'' || DATETIMESTR;
   utl_file.put_line (v_file_handle, OUTPUT);
END IF;

utl_file.fclose (v_file_handle);
END;
END;',
start_date => systimestamp,
repeat_interval => 'FREQ=DAILY;INTERVAL=1;BYHOUR=06;BYMINUTE=40;',
enabled => TRUE);
END;
/


