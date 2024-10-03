BEGIN
DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'CLEAN_TABLESPACES');
END;
/

BEGIN
dbms_scheduler.create_job(job_name => 'CLEAN_TABLESPACES',
job_type => 'PLSQL_BLOCK',
job_action => '
BEGIN
DECLARE 
MCOUNT INTEGER;
MCOUNT2 INTEGER;
BEGIN

   SELECT COUNT(*) INTO MCOUNT FROM DBA_SEGMENTS WHERE TABLESPACE_NAME IN (''IA_DYNOBJECTS_IDX'');
   IF(MCOUNT = 0) THEN
        SELECT COUNT(1) INTO MCOUNT2 FROM USER_TABLESPACES WHERE TABLESPACE_NAME = ''IA_DYNOBJECTS_IDX'';
        IF (MCOUNT2 = 1) THEN
        	EXECUTE IMMEDIATE ''DROP TABLESPACE IA_DYNOBJECTS_IDX INCLUDING CONTENTS AND DATAFILES'';
        END IF;
        EXECUTE IMMEDIATE ''CREATE TABLESPACE IA_DYNOBJECTS_IDX DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO''; 
        EXECUTE IMMEDIATE ''ALTER USER IAUSER  QUOTA UNLIMITED ON IA_DYNOBJECTS_IDX''; 
         
   END IF;

   SELECT COUNT(*) INTO MCOUNT FROM DBA_SEGMENTS WHERE TABLESPACE_NAME IN (''IA_DYNOBJECTS_IDX2'');
   
      IF(MCOUNT = 0) THEN
        SELECT COUNT(1) INTO MCOUNT2 FROM USER_TABLESPACES WHERE TABLESPACE_NAME = ''IA_DYNOBJECTS_IDX2'';
        IF (MCOUNT2 = 1) THEN
         EXECUTE IMMEDIATE ''DROP TABLESPACE IA_DYNOBJECTS_IDX2 INCLUDING CONTENTS AND DATAFILES'';
        END IF;
        EXECUTE IMMEDIATE ''CREATE TABLESPACE IA_DYNOBJECTS_IDX2 DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO''; 
        EXECUTE IMMEDIATE ''ALTER USER IAUSER  QUOTA UNLIMITED ON IA_DYNOBJECTS_IDX2''; 
      END IF;

   SELECT COUNT(*) INTO MCOUNT FROM DBA_SEGMENTS WHERE TABLESPACE_NAME IN (''ER_DYNOBJECTS_IDX'');
   IF(MCOUNT = 0) THEN
        SELECT COUNT(1) INTO MCOUNT2 FROM USER_TABLESPACES WHERE TABLESPACE_NAME = ''ER_DYNOBJECTS_IDX'';
        IF (MCOUNT2 = 1) THEN
          EXECUTE IMMEDIATE ''DROP TABLESPACE ER_DYNOBJECTS_IDX INCLUDING CONTENTS AND DATAFILES'';
        END IF;
        EXECUTE IMMEDIATE ''CREATE TABLESPACE ER_DYNOBJECTS_IDX DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO''; 
        EXECUTE IMMEDIATE ''ALTER USER ERUSER  QUOTA UNLIMITED ON ER_DYNOBJECTS_IDX''; 
   END IF;

   SELECT COUNT(*) INTO MCOUNT FROM DBA_SEGMENTS WHERE TABLESPACE_NAME IN (''ER_DYNOBJECTS_IDX2'');
   IF(MCOUNT = 0) THEN
        SELECT COUNT(1) INTO MCOUNT2 FROM USER_TABLESPACES WHERE TABLESPACE_NAME = ''ER_DYNOBJECTS_IDX2'';
    	IF (MCOUNT2 = 1) THEN
          EXECUTE IMMEDIATE ''DROP TABLESPACE ER_DYNOBJECTS_IDX2 INCLUDING CONTENTS AND DATAFILES'';
     	END IF;
        EXECUTE IMMEDIATE ''CREATE TABLESPACE ER_DYNOBJECTS_IDX2 DATAFILE SIZE 100M AUTOEXTEND ON NEXT 100M EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO''; 
        EXECUTE IMMEDIATE ''ALTER USER ERUSER  QUOTA UNLIMITED ON ER_DYNOBJECTS_IDX2''; 
   END IF;

END; 
END;',
start_date => systimestamp,
repeat_interval => 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SAT;BYHOUR=7;BYMINUTE=30;BYSECOND=0;',
enabled => TRUE);
END;
/