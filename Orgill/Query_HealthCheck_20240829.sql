/*
Export query result to file:
On SSMS -> Query -> Result to -> Result To File
Save it as *.rpt file (default)
*/


-- 1) SQL Server version and edition and Window server version

SELECT @@VERSION;

-- 2) SQL Server Memory in Use and Max memory

SELECT object_name ,counter_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name IN  ('Total Server Memory (KB)', 'Target Server Memory (KB)', 'Max memory (KB)');

--3)  File size

SELECT 
    fg.name AS [FileGroupName],
    mf.name AS [LogicalFileName],
    mf.type_desc AS [FileType],
    mf.size * 8 / 1024 / 1024 AS [SizeGB],  
    CASE WHEN mf.max_size < 0 THEN -1 ELSE mf.max_size * 8.0 / 1024 / 1024 END  AS [MaxSizeGB], 
    mf.growth * 8 / 1024 / 1024 AS [GrowthGB], 
    mf.is_percent_growth AS [IsPercentGrowth],
	mf.growth
FROM sys.master_files AS mf
JOIN sys.filegroups AS fg ON mf.data_space_id = fg.data_space_id
WHERE  mf.database_id = DB_ID() 
ORDER BY mf.size DESC;


-- 4) Physical Memory and CPU count in Windows Server
SELECT
	cpu_count,
    CEILING(physical_memory_kb/1024/1024.00) AS physical_memory_GB, 
	virtual_machine_type,
	virtual_machine_type_desc, 
	container_type,
	container_type_desc
FROM sys.dm_os_sys_info;


-- 5) Buffer cache hit ratio should be > 80%
SELECT  
    counter_name AS 'CounterName',
    cntr_value AS 'BufferCacheHitRatio' 
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Buffer cache hit ratio'

-- 6) Page fault should be small, compare it with SQL Server memory
SELECT
    page_fault_count,
	CEILING( page_fault_count * 8.00 / 1024/1024.00) AS page_fault_GB, 
    memory_utilization_percentage,
    CEILING( available_commit_limit_kb/1024/1024.00) AS available_commit_limit_GB
FROM sys.dm_os_process_memory;

-- 7) IO
SELECT 
    wait_type,
    waiting_tasks_count,
    wait_time_ms / 1000.0 AS wait_time_sec,
	wait_time_ms / 1000.0 / 60 / 60 AS wait_time_hour,
    (wait_time_ms - signal_wait_time_ms) / 1000.0 AS resource_wait_sec,
    signal_wait_time_ms / 1000.0 AS signal_wait_sec,
    CAST((100.0 * wait_time_ms / SUM(wait_time_ms) OVER()) AS DECIMAL(19, 2)) AS percentage,
	wait_time_ms / CASE WHEN waiting_tasks_count = 0 OR waiting_tasks_count IS NULL THEN 1 ELSE waiting_tasks_count END AS wait_ms_per_task
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'PAGEIOLATCH%' OR 
    wait_type LIKE 'IO_COMPLETION%' OR 
    wait_type LIKE 'WRITELOG%' 
ORDER BY wait_time_sec DESC;


-- 8) Check database level user role:

SELECT 
    u.name AS UserName,
    r.name AS RoleName
FROM sys.database_principals u
LEFT JOIN sys.database_role_members rm ON u.principal_id = rm.member_principal_id
LEFT JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
WHERE u.type IN ('S', 'U', 'G') -- S = SQL User, U = Windows User, G = Windows Group
ORDER BY u.name;


-- 9) Error log (This query might takes longer than 10 seconds)
EXEC sp_readerrorlog 0, 2;

-- 10) Agent Error log (This query might takes longer than 10 seconds)
EXEC sp_readerrorlog 1, 2;


-- 11) Get Log for last 30 days (This query might takes longer than 10 seconds)
DECLARE @EndDate DATETIME = GETDATE();
DECLARE @StartDate DATETIME = DATEADD(day, -30, @EndDate);
EXEC xp_readerrorlog 0, 1, NULL, NULL, @StartDate, @EndDate;


-- 12) Check Audit option, please take screenshot or write down the data:
-- SSMS -> server properties -> Security -> Login auditing
-- SSMS -> server properties -> Security -> Options 
-- SSMS -> server properties -> Security -> Server authentication