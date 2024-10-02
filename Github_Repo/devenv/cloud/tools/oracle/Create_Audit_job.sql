-- Preparation
-- Check audit table information
SQL> select * from dba_tables where table_name IN ('AUD$', 'FGA_LOG$');
-- Create new tablespace for audit data.
-- For RDS Oracle:
SQL> CREATE TABLESPACE AUDIT_AUX DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
-- Move audit table to new tablespace.
SQL>
BEGIN
DBMS_AUDIT_MGMT.set_audit_trail_location(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
audit_trail_location_value => 'AUDIT_AUX');
END;
/
BEGIN
DBMS_AUDIT_MGMT.set_audit_trail_location(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD,
audit_trail_location_value => 'AUDIT_AUX');
END;
/

/*
Please note:
If we see deadlock errors, temporarily set RDS Oracle parameter DB_AUDIT_TRAIL to NONE, restart the database, and try the operations again.
- You can revert DB_AUDIT_TRAIL after the process completes (reboot again).
*/

-- Check audit table again.
SQL> select * from dba_tables where table_name IN ('AUD$', 'FGA_LOG$');
-- Turn on audit
-- Set parameter "Audit_trail" to DB,EXTEND on AWS RDS Management Console by setting parameter groups
-- Show parameters audit_trail
SQL> SELECT * FROM   dba_audit_mgmt_config_params
-- Turn on audit event
SQL>
AUDIT ALTER DATABASE; 
AUDIT ALTER SYSTEM;
AUDIT ALTER TABLE;
AUDIT ALTER TABLESPACE;
AUDIT ALTER USER;
AUDIT CREATE OPERATOR;
AUDIT CREATE ROLE;
AUDIT CREATE SESSION;
AUDIT CREATE TABLE;
AUDIT CREATE TABLESPACE;
AUDIT CREATE TRIGGER;
AUDIT CREATE USER;
AUDIT CREATE VIEW;
AUDIT DELETE TABLE;
AUDIT DROP TABLESPACE;
AUDIT DROP USER;
AUDIT INSERT ANY TABLE;
AUDIT LOCK TABLE;
AUDIT UPDATE TABLE;

SELECT audit_option, success, failure FROM dba_stmt_audit_opts;

-- Initialize the Audit
SQL>
BEGIN
  DBMS_AUDIT_MGMT.INIT_CLEANUP(
    AUDIT_TRAIL_TYPE => DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
    DEFAULT_CLEANUP_INTERVAL => 24 /*hours*/
  );
END;
/
-- check it initialized
SQL>
   SET SERVEROUTPUT ON
 BEGIN
   IF DBMS_AUDIT_MGMT.is_cleanup_initialized(DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL) THEN
     DBMS_OUTPUT.put_line('YES');
   ELSE
     DBMS_OUTPUT.put_line('NO');
   END IF;
 END;
/

SQL>
BEGIN
  DBMS_AUDIT_MGMT.set_last_archive_timestamp(
    audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
    last_archive_time => SYSTIMESTAMP-365);
END;
/

-- Deinitialize if needed
/*
BEGIN
dbms_audit_mgmt.deinit_cleanup(
AUDIT_TRAIL_TYPE => dbms_audit_mgmt.AUDIT_TRAIL_ALL
);
END;
/
*/

-- Automate purging job to reset last archive time
-- Reset the last archive time to a year (365 days)

SQL>

BEGIN
DBMS_SCHEDULER.create_job (
job_name => 'audit_last_archive_time',
job_type => 'PLSQL_BLOCK',
job_action => 'BEGIN 
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, TRUNC(SYSTIMESTAMP)-365);
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, TRUNC(SYSTIMESTAMP)-365);
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS, TRUNC(SYSTIMESTAMP)-365);
DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML, TRUNC(SYSTIMESTAMP)-365);
END;',
start_date => SYSTIMESTAMP,
repeat_interval => 'freq=daily; byhour=0; byminute=0; bysecond=0;',
end_date => NULL,
enabled => TRUE,
comments => 'Automatically set audit last archive time.');
END;
/

/*
-- drop job if needed
BEGIN
DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'audit_last_archive_time');
END;
/

*/


-- Create purging job
SQL>

BEGIN
DBMS_AUDIT_MGMT.create_purge_job(
audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
audit_trail_purge_interval => 24 /* hours */, 
audit_trail_purge_name => 'PURGE_ALL_AUDIT_TRAILS',
use_last_arch_timestamp => TRUE);
END;
/

-- Disable/enable purging job if needed.
SQL>
/*
BEGIN
DBMS_AUDIT_MGMT.set_purge_job_status(
audit_trail_purge_name => 'PURGE_ALL_AUDIT_TRAILS',
audit_trail_status_value => DBMS_AUDIT_MGMT.PURGE_JOB_DISABLE);
END;
/
*/

BEGIN

DBMS_AUDIT_MGMT.set_purge_job_status(
audit_trail_purge_name => 'PURGE_ALL_AUDIT_TRAILS',
audit_trail_status_value => DBMS_AUDIT_MGMT.PURGE_JOB_ENABLE);
END;
/

-- Drop purging job if needed

BEGIN
DBMS_AUDIT_MGMT.drop_purge_job(
audit_trail_purge_name => 'PURGE_ALL_AUDIT_TRAILS');
END;
/

 -- Check Audit records
 
 SQL> select * from SYS.AUD$ ORDER BY NTIMESTAMP# DESC;
 
 SELECT os_username, username, userhost, extended_timestamp, action, action_name, returncode as return
 FROM dba_audit_trail
 WHERE action_name = 'LOGON'
ORDER BY TIMESTAMP desc;

 SELECT job_name,job_status,audit_trail,job_frequency FROM dba_audit_mgmt_cleanup_jobs; 
 SELECT job_name, next_run_date, state, enabled FROM dba_scheduler_jobs WHERE job_name LIKE '%AUDIT%'; 