

/*********************************************************
        Section One
   Reclaim disk space from data file.
**********************************************************/

/*
-- Find out the datafile that needs shrinking
select file_name,
ceil( (nvl(hwm,1)*8192)/1024/1024 ) SHRINK_TO,
ceil( blocks*8192/1024/1024) CURRENT_SIZE,
ceil( blocks*8192/1024/1024) -
ceil( (nvl(hwm,1)*8192)/1024/1024 ) SAVINGS
from dba_data_files a,
( select file_id, max(block_id+blocks-1) hwm
from dba_extents
group by file_id ) b
where a.file_id = b.file_id
and ceil( blocks*8192/1024/1024) > ceil( (nvl(hwm,1)*8192)/1024/1024 )
and ceil( blocks*8192/1024/1024) > 100 order by 4 desc;
*/


------------------------------------
-- Run the following query, copy/paste the SQL statement and run each of them seperately.
------------------------------------
select 
'alter database datafile ''' || file_name || ''' resize ' || ceil( (nvl(hwm,1)*8192)/1024/1024 ) || 'M;' AS MSQL
from dba_data_files a,
( select file_id, max(block_id+blocks-1) hwm
from dba_extents
group by file_id ) b
where a.file_id = b.file_id
and ceil( blocks*8192/1024/1024) > ceil( (nvl(hwm,1)*8192)/1024/1024 )
and ceil( blocks*8192/1024/1024) > 100 
order by ceil( (nvl(hwm,1)*8192)/1024/1024 ) desc;


/*********************************************************
        Section Two
   Reclaim disk space from index by using the script in file DB_Reclaim_Index_Space_Steps.sql
   If it does not regain enough disk space fter finish Section one (for datafile), 
   then try execute query in this section. 
   After this section, RERUN Section One.
**********************************************************/

/*********************************************************
        Section Three
   Reclaim disk space from table data.
   If it does not regain enough disk space fter finish Section one (for datafile), 
   then try execute query in this section. 
   After this section, RERUN Section One.
**********************************************************/
/***************************
Step 1: Gather statistic informations
****************************/

/*

begin
    dbms_stats.gather_schema_stats ('IAUSER');
end;
/
begin
    dbms_stats.gather_schema_stats ('ERUSER');
end;
/
begin
    dbms_stats.gather_schema_stats ('IVUSER');
end;
/
begin
    dbms_stats.gather_schema_stats ('IIUSER');
end;
/
begin
    dbms_stats.gather_schema_stats ('ISUSER');
end;
/
begin
    dbms_stats.gather_schema_stats ('EBUSER');
end;
/
*/

-- check 
select 
a.owner, 
a.segment_name, 
a.segment_type, 
round(a.bytes/1024/1024,0) MBS, 
round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0) WASTED 
from dba_segments a, dba_tables b 
where a.owner=b.owner 
and a.owner not like 'SYS%' 
and a.segment_name = b.table_name 
and a.segment_type='TABLE' 
group by a.owner, a.segment_name, a.segment_type, round(a.bytes/1024/1024,0) ,round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0) 
having round(bytes/1024/1024,0) >100 
order by round(bytes/1024/1024,0) desc ; 

select owner, table_name, round((num_rows*avg_row_len)/(1024*1024)) MB
,num_rows,avg_row_len, BLOCKS, EMPTY_BLOCKS, EMPTY_BLOCKS / BLOCKS AVG_EMPTY_BLOCKS
from dba_tables 
where owner not like 'SYS%'  and owner not like 'APEX%' and owner not like '%SYS'
and EMPTY_BLOCKS > 100 
and round((num_rows*avg_row_len)/(1024*1024)) > 100 
order by AVG_EMPTY_BLOCKS desc, MB desc;

------------------------------------
-- Run the following query, copy/paste the SQL statement and run each of them seperately.
------------------------------------
SELECT 'alter table "' || owner || '"."' || segment_name || '" enable row movement;'
/*|| ' alter table "' || owner || '"."' || segment_name || '" shrink space;'*/
|| ' alter table "' || owner || '"."' || segment_name || '" shrink space cascade;'
|| ' alter table "' || owner || '"."' || segment_name || '" disable row movement;' AS MSQL FROM (
select 
a.owner, 
a.segment_name, 
a.segment_type, 
round(a.bytes/1024/1024,0) MBS, 
round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0) WASTED 
from dba_segments a, dba_tables b 
where a.owner=b.owner 
and a.owner not like 'SYS%' 
and a.segment_name = b.table_name 
and a.segment_type='TABLE' 
group by a.owner, a.segment_name, a.segment_type, round(a.bytes/1024/1024,0) ,round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0) 
having round(bytes/1024/1024,0) >100 
order by round(bytes/1024/1024,0) desc) X ; 

select 'alter table "' || owner || '"."' || table_name || '" enable row movement;'
/*|| ' alter table "' || owner || '"."' || table_name || '" shrink space;'*/
|| ' alter table "' || owner || '"."' || table_name || '" shrink space cascade;'
|| ' alter table "' || owner || '"."' || table_name || '" disable row movement;' AS MSQL
from dba_tables 
where owner not like 'SYS%'  and owner not like 'APEX%' and owner not like '%SYS'
and EMPTY_BLOCKS > 100 
and round((num_rows*avg_row_len)/(1024*1024)) > 100 
order by EMPTY_BLOCKS / BLOCKS desc, 
round((num_rows*avg_row_len)/(1024*1024)) desc;

/*********************************************************
        Section Four
   Reclaim disk space from temp file. 
**********************************************************/

SQL> SELECT * FROM dba_temp_free_space;

TABLESPACE_NAME                TABLESPACE_SIZE ALLOCATED_SPACE FREE_SPACE
------------------------------ --------------- --------------- ----------
TEMP                                5662310400      5662310400   5557452800

SQL> ALTER TABLESPACE temp SHRINK SPACE KEEP 1G;

Tablespace altered.

SQL> SELECT * FROM dba_temp_free_space;

TABLESPACE_NAME                TABLESPACE_SIZE ALLOCATED_SPACE FREE_SPACE
------------------------------ --------------- --------------- ----------
TEMP                                1073741824         1048576 1072693248


