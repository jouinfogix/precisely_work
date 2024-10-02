CREATE OR REPLACE PROCEDURE 
PROC_GET_CONTROLSIZE(
  Owner VARCHAR2,
  strSearch VARCHAR2,
  strExcludedOne VARCHAR2,
  strExcludedTwo VARCHAR2
)
AS
  SizeCountMB INTEGER;
BEGIN

  SELECT
   TRUNC(sum(X.bytes)/1024/1024) INTO SizeCountMB
  FROM
   (SELECT segment_name table_name, owner, bytes
   FROM dba_segments
   WHERE segment_type in  ('TABLE','TABLE PARTITION')
   UNION ALL
   SELECT i.table_name, i.owner, s.bytes
   FROM dba_indexes i, dba_segments s
   WHERE s.segment_name = i.index_name
   AND   s.owner = i.owner
   AND   s.segment_type in ('INDEX','INDEX PARTITION')
   UNION ALL
   SELECT l.table_name, l.owner, s.bytes
   FROM dba_lobs l, dba_segments s
   WHERE s.segment_name = l.segment_name
   AND   s.owner = l.owner
   AND   s.segment_type IN ('LOBSEGMENT','LOB PARTITION')
   UNION ALL
   SELECT l.table_name, l.owner, s.bytes
   FROM dba_lobs l, dba_segments s
   WHERE s.segment_name = l.index_name
   AND   s.owner = l.owner
   AND   s.segment_type = 'LOBINDEX') X
   WHERE 
     EXISTS(SELECT T.table_name, T.tablespace_name FROM dba_tables T 
            WHERE T.table_name = X.table_name AND T.owner = X.owner AND
                  T.owner = Owner AND 
                 (T.table_name LIKE 'UP/_%' || strSearch || '/_%' ESCAPE '/' AND 
                  T.table_name NOT LIKE 'UP/_%' || strExcludedOne || '/_%' ESCAPE '/'  AND 
                  T.table_name NOT LIKE 'UP/_%' || strExcludedTwo || '/_%' ESCAPE '/' ));

END; 

/