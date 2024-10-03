

/*******************************************
Step 1: Create a utility table table
*******************************************/

create table MY_INDEX_STATS (
        TABLE_OWNER        varchar2(100),
        NAME              varchar2(100),
        DEL_LF_ROWS             number(8),
        LF_ROWS                 number(8)
        
);

/*******************************************
Step 2: Build index online
        It will prompt for SchemaName
*******************************************/

declare
  l_SQL varchar2(1000);
  l_SQL2 varchar2(1000);
begin
  for cur in (
    select indx.TABLE_OWNER, indx.INDEX_NAME
    from all_indexes indx
    where indx.TABLE_TYPE='TABLE' AND indx.TABLE_OWNER IN ('&SchemaName')
    )
  loop
    l_SQL := 'ANALYZE INDEX ' || cur.TABLE_OWNER ||  '.' || cur.INDEX_NAME|| ' COMPUTE STATISTICS';
    --DBMS_OUTPUT.PUT_LINE(l_SQL);
    execute immediate l_SQL;
    l_SQL := 'ANALYZE INDEX ' || cur.TABLE_OWNER ||  '.' || cur.INDEX_NAME|| ' VALIDATE STRUCTURE';
    --DBMS_OUTPUT.PUT_LINE(l_SQL);
    execute immediate l_SQL;
    l_SQL := ' insert into MY_INDEX_STATS(TABLE_OWNER, NAME,DEL_LF_ROWS, LF_ROWS) select ''' || cur.TABLE_OWNER || ''', NAME, DEL_LF_ROWS, LF_ROWS from index_stats';
    --DBMS_OUTPUT.PUT_LINE(l_SQL);
    execute immediate l_SQL;
    begin
      for cur2 in (
        select indx.TABLE_OWNER, indx.NAME
        from MY_INDEX_STATS indx
        where (DEL_LF_ROWS > 0 AND LF_ROWS > 0 AND DEL_LF_ROWS / LF_ROWS > 0.3) OR LF_ROWS =0
        )
      loop
        --l_SQL2 := 'ALTER INDEX ' || cur.TABLE_OWNER ||  '.' || cur.INDEX_NAME|| ' REBUILD ONLINE';
        l_SQL2 := 'ALTER INDEX ' || cur.TABLE_OWNER ||  '.' || cur.INDEX_NAME|| ' REBUILD';
        --DBMS_OUTPUT.PUT_LINE(l_SQL2);
        execute immediate l_SQL2;
      end loop;
    end;
    l_SQL := 'truncate table MY_INDEX_STATS';
    execute immediate l_SQL;
  end loop;
end;

/*******************************************
Step 3: Drop utility table
*******************************************/
DROP TABLE MY_INDEX_STATS;
COMMIT;