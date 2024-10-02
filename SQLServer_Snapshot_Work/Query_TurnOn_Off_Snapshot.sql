
--------------------------------------------------------------------------------------------
-- Two Statements to turn on SQL Server Snapshot isolation. Please execute them one at a time.
--------------------------------------------------------------------------------------------
-- Execute the first statement, it should only take couple of seconds.
ALTER DATABASE [YourDatabase]
SET ALLOW_SNAPSHOT_ISOLATION ON  

-- Execute the second statment, if it hangs for 5 minutes, then cancel the query, restart the SQL Server instance
--  try it again, it always working after reboot. 
  
ALTER DATABASE [YourDatabase]
SET READ_COMMITTED_SNAPSHOT ON

--------------------------------------------------------------------------------------------
-- Two Statements to turn off SQL Server Snapshot isolation. Please execute them one at a time.
--------------------------------------------------------------------------------------------

-- Execute the statment to turn off READ Snapshot, if it hangs for 5 minutes, then cancel the query, restart the SQL Server instance
--  try it again, it always working after reboot. 
  
ALTER DATABASE [YourDatabase]
SET READ_COMMITTED_SNAPSHOT OFF

-- Execute the statement to turn off Snapshot isolation, it should only take couple of seconds.
ALTER DATABASE [YourDatabase]
SET ALLOW_SNAPSHOT_ISOLATION OFF  


----------------------------------------------------------------------------

-- Query to verify if the snapshot isolation flags turned on

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

-------------------------------------
-- Query to check the tempdb size (or can see it through MMC directly)

-- By default tempdb has 8 files, column "tempdb_pages" is for each file. Each file should be the same size
-- Total tempdb size (GB) will be: tempdb_pages * 8.00 * 8.00 / 1024 / 1024

SELECT DB_NAME(vsu.database_id) AS DatabaseName,
          vsu.reserved_page_count, 
          vsu.reserved_space_kb, 
          tu.total_page_count as tempdb_pages, 
          vsu.reserved_page_count * 100. / tu.total_page_count AS [Snapshot %],
          tu.allocated_extent_page_count * 100. / tu.total_page_count AS [tempdb % used]
   FROM sys.dm_tran_version_store_space_usage vsu
        CROSS JOIN tempdb.sys.dm_db_file_space_usage tu
   WHERE vsu.database_id = DB_ID(DB_NAME());

------------------------------------------
-- column "data" will return the data size of the table and we need up to 80% of this size for tempdb

sp_spaceused 'B_MASTER_REPOSITORY_ITEM'

