
/******    Superuser grant permission  ******/ 
GRANT CREATE JOB TO IAUSER;
/

BEGIN
DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'IAUSER.REBUILDINDEXES');
END;
/


/******    IAUSER create job  ******/ 

BEGIN
dbms_scheduler.create_job(job_name => 'REBUILDINDEXES',
job_type => 'STORED_PROCEDURE',
job_action => 'PROC_MOVE_ONE_PRODUCT_INDEXES',
start_date => systimestamp,
repeat_interval => 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SAT;BYHOUR=3;BYMINUTE=0;BYSECOND=0;',
enabled => TRUE);
END;
/

/******    Superuser grant permission  ******/ 

GRANT CREATE JOB TO ERUSER;
/

BEGIN
DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'ERUSER.REBUILDINDEXES');
END;
/


/******    ERUSER create job  ******/ 


BEGIN
dbms_scheduler.create_job(job_name => 'REBUILDINDEXES',
job_type => 'STORED_PROCEDURE',
job_action => 'PROC_MOVE_ONE_PRODUCT_INDEXES',
start_date => systimestamp,
repeat_interval => 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SAT;BYHOUR=4;BYMINUTE=30;BYSECOND=0;',
enabled => TRUE);
END;
/