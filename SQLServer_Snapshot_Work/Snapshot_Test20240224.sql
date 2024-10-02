
Reference:

Update 6 GB of data, tempdb 4.5 GB
Update 4 GB of data, tempdb 4.5 GB



https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/sql/snapshot-isolation-in-sql-server



SELECT CASE  
    WHEN transaction_isolation_level = 0 THEN 'Unspecified' 
    WHEN transaction_isolation_level = 1 THEN 'Read Uncommitted' 
    WHEN transaction_isolation_level = 2 AND d.snapshot_isolation_state_desc = 'OFF' THEN 'Read Committed' 
    WHEN transaction_isolation_level = 2 AND d.snapshot_isolation_state_desc = 'ON' AND d.is_read_committed_snapshot_on = 1 THEN 'Snapshot Read Committed'  
    WHEN transaction_isolation_level = 2 AND d.snapshot_isolation_state_desc = 'ON' AND d.is_read_committed_snapshot_on = 0 THEN 'Snapshot'  
    WHEN transaction_isolation_level = 3 THEN 'Repeatable Read' 
    WHEN transaction_isolation_level = 4 THEN 'Serializable' END AS TRANSACTION_ISOLATION_LEVEL,
    d.is_read_committed_snapshot_on,
    d.snapshot_isolation_state_desc
FROM sys.dm_exec_sessions 
       CROSS JOIN sys.databases AS d
where session_id = @@SPID
  AND  d.database_id = DB_ID();

SELECT DB_NAME(database_id), 
    is_read_committed_snapshot_on,
    snapshot_isolation_state_desc 
FROM sys.databases
WHERE database_id = DB_ID();


ALTER DATABASE MyDatabase  
SET ALLOW_SNAPSHOT_ISOLATION ON  
  
ALTER DATABASE MyDatabase  
SET READ_COMMITTED_SNAPSHOT ON


-- Show space usage in tempdb
SELECT DB_NAME(vsu.database_id) AS DatabaseName,
    vsu.reserved_page_count, 
    vsu.reserved_space_kb, 
    tu.total_page_count as tempdb_pages, 
    vsu.reserved_page_count * 100. / tu.total_page_count AS [Snapshot %],
    tu.allocated_extent_page_count * 100. / tu.total_page_count AS [tempdb % used]
FROM sys.dm_tran_version_store_space_usage vsu
    CROSS JOIN tempdb.sys.dm_db_file_space_usage tu
WHERE vsu.database_id = DB_ID(DB_NAME());

-----------------------------------------------------
SQL Server snapshot isolation test
Conclusion: 
Snapshot isolation will greatly increase concurrency read performance while transaction going on. 
Meanwhile without snapshot isolation, Concurrent read commit will be blocked.

Concern:
Based on table "B_MASTER_REPOSITORY_ITEM", Snapshot isolation will add 2.2 GB to tempdb while updating 4.1 GB data.
Meanwhile without snapshot isolation, tempdb size will have no change.



--------------------------------------------------------

Tesing queries with Snapshot isolation enabled

--------------------------------------------------------

-----
Step00:  Testing table size
-----

B_MASTER_REPOSITORY_ITEM  
Table size: 6.8 GB
Row count: 3,471,346
REPOSITORY_ID=10340 row count: 2,090,913 (60% of the table)

------
Step01: Get the tempdb info before change to ALLOW_SNAPSHOT_ISOLATION
------
SELECT DB_NAME(vsu.database_id) AS DatabaseName,
    vsu.reserved_page_count, 
    vsu.reserved_space_kb, 
    tu.total_page_count as tempdb_pages, 
    vsu.reserved_page_count * 100. / tu.total_page_count AS [Snapshot %],
    tu.allocated_extent_page_count * 100. / tu.total_page_count AS [tempdb % used]
FROM sys.dm_tran_version_store_space_usage vsu
    CROSS JOIN tempdb.sys.dm_db_file_space_usage tu
WHERE vsu.database_id = DB_ID(DB_NAME());

Result:
Each of tempdbfile size(total 8 files): reserved_page_count=0; reserved_space_kb=0; tempdb_pages=1024 each file; Snapshot %=0; 

------
Step02: Set the database to ALLOW_SNAPSHOT_ISOLATION. I'm using database EPIM 
------
-- It might require restart SQL Server service to make the following 2 statements work.
ALTER DATABASE [EPIM]
SET ALLOW_SNAPSHOT_ISOLATION ON  
  
ALTER DATABASE [EPIM]
SET READ_COMMITTED_SNAPSHOT ON

-- Reboot SQL Server

-- Check READ_COMMITED_SNAPSHOT
SELECT CASE  
    WHEN transaction_isolation_level = 0 THEN 'Unspecified' 
    WHEN transaction_isolation_level = 1 THEN 'Read Uncommitted' 
    WHEN transaction_isolation_level = 2 AND d.snapshot_isolation_state_desc = 'OFF' THEN 'Read Committed' 
    WHEN transaction_isolation_level = 2 AND d.snapshot_isolation_state_desc = 'ON' AND d.is_read_committed_snapshot_on = 1 THEN 'Snapshot Read Committed'  
    WHEN transaction_isolation_level = 2 AND d.snapshot_isolation_state_desc = 'ON' AND d.is_read_committed_snapshot_on = 0 THEN 'Snapshot'  
    WHEN transaction_isolation_level = 3 THEN 'Repeatable Read' 
    WHEN transaction_isolation_level = 4 THEN 'Serializable' END AS TRANSACTION_ISOLATION_LEVEL,
    d.is_read_committed_snapshot_on,
    d.snapshot_isolation_state_desc
FROM sys.dm_exec_sessions 
       CROSS JOIN sys.databases AS d
where session_id = @@SPID
  AND  d.database_id = DB_ID();

------
Step03: Preparing queries, DO NOT execute any query at this step yet
------
-- Find a Repository_ID with large amount of rows.
select TOP 10 Repository_ID, count(*) as cnt from B_MASTER_REPOSITORY_ITEM
group by Repository_ID
order by 2 desc

I'm using Repository_ID = 10340 that has 2,090,913 (out of 3,471,346) rows for testing 60% of data in 6.3GB table

   Open query session 1 for update statement
   --------------------

   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

   BEGIN TRAN;
   UPDATE B_MASTER_REPOSITORY_ITEM SET MERGED_INTO_ITEM_ID = ITEM_ID
   where Repository_ID = 10340 AND MERGED_INTO_ITEM_ID IS NULL;
   /* COMMIT; */


   Open query session 2 for getting tempdb data file size
   --------------------

   SELECT DB_NAME(vsu.database_id) AS DatabaseName,
          vsu.reserved_page_count, 
          vsu.reserved_space_kb, 
          tu.total_page_count as tempdb_pages, 
          vsu.reserved_page_count * 100. / tu.total_page_count AS [Snapshot %],
          tu.allocated_extent_page_count * 100. / tu.total_page_count AS [tempdb % used]
   FROM sys.dm_tran_version_store_space_usage vsu
        CROSS JOIN tempdb.sys.dm_db_file_space_usage tu
   WHERE vsu.database_id = DB_ID(DB_NAME());


   Open query session 3 try to retrieve data from un-committed snapshot
   --------------------
   SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SELECT COUNT(*) as cnt FROM B_MASTER_REPOSITORY_ITEM
   WHERE Repository_ID = 10340 AND MERGED_INTO_ITEM_ID IS NULL;


   Open query session 4 try to retrieve data  from committed snapshot
   --------------------
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
   SELECT COUNT(*) as cnt FROM B_MASTER_REPOSITORY_ITEM
   WHERE Repository_ID = 10340 AND MERGED_INTO_ITEM_ID IS NULL;

------
Step04: Execute 4 query sessions
------

Execute query session 1 (without "COMMIT;")
Execute query session 2 to see the tempdb usage:
  Each of tempdbfile size(total 8 files); reserved_page_count=211576; reserved_space_kb=1692608; tempdb_pages=33792; Snapshot %=626;
Execute query session 3 to see the result: Read Committed returns count 2,090,913
Execute query session 4 to see the result: Read Uncommited returns count 0

------
Step05: Check result after commit
------
Goes to query session 1, execute commit command:
COMMIT;

Execute query session 2 to see the tempdb usage:
  Each of tempdbfile size(total 8 files); reserved_page_count=0; reserved_space_kb=0; tempdb_pages=1024; Snapshot %=0;

Execute query session 3 to see the result: Read Committed returns count 0
Execute query session 4 to see the result: Read Uncommited returns count 0

------
Step06: Rollback testing data
------

-- It might require restart SQL Server service to make the following 2 statements work.
ALTER DATABASE [EPIM] SET READ_COMMITTED_SNAPSHOT OFF
ALTER DATABASE [EPIM] SET ALLOW_SNAPSHOT_ISOLATION OFF
-- Reboot SQL Server


UPDATE B_MASTER_REPOSITORY_ITEM SET MERGED_INTO_ITEM_ID = NULL
WHERE Repository_ID = 10340 AND MERGED_INTO_ITEM_ID = ITEM_ID;

----------------------------------------------------------------------------------

Tesing queries without Snapshot isolation enabled

--------------------------------------------------------

Query session 1, table locked
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

   BEGIN TRAN;
   UPDATE B_MASTER_REPOSITORY_ITEM SET MERGED_INTO_ITEM_ID = ITEM_ID
   where Repository_ID = 10340 AND MERGED_INTO_ITEM_ID IS NULL;
   /* COMMIT; */

Query session 2 check tempdb without size increase.

SELECT DB_NAME(vsu.database_id) AS DatabaseName,
          vsu.reserved_page_count, 
          vsu.reserved_space_kb, 
          tu.total_page_count as tempdb_pages, 
          vsu.reserved_page_count * 100. / tu.total_page_count AS [Snapshot %],
          tu.allocated_extent_page_count * 100. / tu.total_page_count AS [tempdb % used]
   FROM sys.dm_tran_version_store_space_usage vsu
        CROSS JOIN tempdb.sys.dm_db_file_space_usage tu
   WHERE vsu.database_id = DB_ID(DB_NAME());


Query session 3 will wait, no result ( Can not do concurrent read commit)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
   SELECT COUNT(*) as cnt FROM B_MASTER_REPOSITORY_ITEM
   WHERE Repository_ID = 10340 AND MERGED_INTO_ITEM_ID IS NULL;


Query session 4 return 0 (dirty read any way)

   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
   SELECT COUNT(*) as cnt FROM B_MASTER_REPOSITORY_ITEM
   WHERE Repository_ID = 10340 AND MERGED_INTO_ITEM_ID IS NULL;

Go to query session 1, execute
COMMIT;

Both query session 2 and 3 will return count: 0











