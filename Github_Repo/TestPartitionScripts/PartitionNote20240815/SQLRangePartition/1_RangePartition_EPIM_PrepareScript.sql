
SET NOCOUNT ON;

DECLARE 
		@NumOfSelectedItem INT = 6  /* Pick up TOP 6 largest Repository */
		,@DatabaseName VARCHAR(100) = 'EPIM'
        ,@GroupFileLocation VARCHAR(1000) = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data' --Must End with "\"
		,@IndexGroupFileLocation VARCHAR(1000) = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data' --Must End with "\"
		;
		/* RDS always has fixed GroupFileLocation: D:\rdsdbdata\DATA\  */
		 SET @GroupFileLocation = 'D:\rdsdbdata\DATA\';
		 SET @IndexGroupFileLocation = 'D:\rdsdbdata\DATA\';

/*** The Above parameters must be filled in accordingly ***/

/*** Below parameters are option ***/
DECLARE
		@PartitionFuncName VARCHAR(100) = 'mPartitionFunction',

		@FileGroupName VARCHAR(100) = 'mFileGroup',
		@FileName VARCHAR(100) = 'mFile',
		@FileLogicName VARCHAR(100) = 'mFile',
		@FileSIZE VARCHAR(10) = '10MB',
		@FileMAXSIZE VARCHAR(20) = 'UNLIMITED',
		@FileFILEGROWTH VARCHAR(20) = '10MB',
		@PartitionSchemeName VARCHAR(100) = 'mPartitionScheme',
		
		@IndexFileGroupName VARCHAR(100) = 'mIndexFileGroup',
		@IndexFileName VARCHAR(100) = 'mIndexFile',
		@IndexFileLogicName VARCHAR(100) = 'mIndexFile',
		@IndexFileSIZE VARCHAR(10) = '10MB',
		@IndexFileMAXSIZE VARCHAR(20) = 'UNLIMITED',
		@IndexFileFILEGROWTH VARCHAR(20) = '10MB',
		@IndexPartitionSchemeName VARCHAR(100) = 'mIndexPartitionScheme';

/*** Do not change the parameters below ***/
DECLARE		  
		@NumOfFileGroup INT = 1,
		@CurrentRep_ID BIGINT,
		@PrevioustRep_ID BIGINT = 0,
		@PrimaryKeyFileGroupName VARCHAR(50),
		@PrimaryKeyConstraintName VARCHAR(100),
		@NewLine VARCHAR(15) = CHAR(13) + CHAR(10),
		@SQL_PartitionFunction VARCHAR(1000) = '',
		@SQL_PartitionScheme VARCHAR(1000) = '',
		@SQL_FileGroup VARCHAR(MAX) = '',
		@SQL_IndexPartitionScheme VARCHAR(1000) = '',
		@SQL_IndexFileGroup VARCHAR(MAX) = '',
		@SQL_CreateClusteredIndex VARCHAR(1000) = '',
		@SQL_IndexPartition VARCHAR(MAX) = '';

		SET @GroupFileLocation = TRIM(@GroupFileLocation);
		SET @GroupFileLocation = CASE WHEN RIGHT(@GroupFileLocation, 1) <> '\' AND RIGHT(@GroupFileLocation, 1) <> '/' THEN @GroupFileLocation + '\' ELSE @GroupFileLocation END;

		SET @IndexGroupFileLocation = TRIM(@IndexGroupFileLocation);
		SET @IndexGroupFileLocation = CASE WHEN RIGHT(@IndexGroupFileLocation, 1) <> '\' AND RIGHT(@IndexGroupFileLocation, 1) <> '/' THEN @IndexGroupFileLocation + '\' ELSE @IndexGroupFileLocation END;


DECLARE @temp AS TABLE (REPOSITORY_ID BIGINT);

INSERT INTO @temp
SELECT TOP(@NumOfSelectedItem) REPOSITORY_ID FROM 
(SELECT REPOSITORY_ID, count(*) as cnt FROM [dbo].[B_MASTER_REPOSITORY_ITEM]
GROUP BY REPOSITORY_ID ) AS X
ORDER BY X.cnt DESC

SET @SQL_PartitionFunction = 'CREATE PARTITION FUNCTION [' + @PartitionFuncName + '] (BIGINT) AS RANGE LEFT FOR VALUES (NULL';

SET @SQL_PartitionScheme = 'CREATE PARTITION SCHEME [' + @PartitionSchemeName + '] AS PARTITION [' + @PartitionFuncName + '] TO ([' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';

SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @FileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     FILENAME = ''' + @GroupFileLocation + @FileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     SIZE = ' + @FileSIZE + ', MAXSIZE = ' + @FileMAXSIZE + ',FILEGROWTH = ' + @FileFILEGROWTH + ' ) TO FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

SET @SQL_IndexPartitionScheme = 'CREATE PARTITION SCHEME [' + @IndexPartitionSchemeName + '] AS PARTITION [' + @PartitionFuncName + '] TO ([' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';

SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @IndexFileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     FILENAME = ''' + @IndexGroupFileLocation + @IndexFileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     SIZE = ' + @IndexFileSIZE + ', MAXSIZE = ' + @IndexFileMAXSIZE + ',FILEGROWTH = ' + @IndexFileFILEGROWTH + ' ) TO FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

SET @NumOfFileGroup = @NumOfFileGroup + 1;
SET @SQL_PartitionScheme = @SQL_PartitionScheme + ',[' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @FileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     FILENAME = ''' + @GroupFileLocation + @FileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     SIZE = ' + @FileSIZE + ', MAXSIZE = ' + @FileMAXSIZE + ',FILEGROWTH = ' + @FileFILEGROWTH + ' ) TO FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

SET @SQL_IndexPartitionScheme = @SQL_IndexPartitionScheme + ',[' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @IndexFileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     FILENAME = ''' + @IndexGroupFileLocation + @IndexFileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     SIZE = ' + @IndexFileSIZE + ', MAXSIZE = ' + @IndexFileMAXSIZE + ',FILEGROWTH = ' + @IndexFileFILEGROWTH + ' ) TO FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

DECLARE db_cursor CURSOR FOR 
SELECT REPOSITORY_ID 
FROM @temp 
ORDER BY REPOSITORY_ID;

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @CurrentRep_ID  

WHILE @@FETCH_STATUS = 0  
BEGIN  

	  --IF @PrevioustRep_ID > 0  -- First Loop
	  --BEGIN
	--	SET @SQL_PartitionFunction = @SQL_PartitionFunction + ','
	  --END
	  SET @SQL_PartitionFunction = @SQL_PartitionFunction + ',';

	  /* If it's the first loop  OR Current REPOSITORY_ID is larger more than 1 then previous REPOSITRY_ID, we need to add additional FileGroup */
	  IF (@PrevioustRep_ID < @CurrentRep_ID - 1 AND @PrevioustRep_ID > 0) OR @PrevioustRep_ID = 0
	  BEGIN
		SET @SQL_PartitionFunction = @SQL_PartitionFunction + CAST(@CurrentRep_ID - 1 AS VARCHAR(20)) + ',';
		SET @NumOfFileGroup = @NumOfFileGroup + 1;
		SET @SQL_PartitionScheme = @SQL_PartitionScheme + ',[' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';

		SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
		SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @FileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
		SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     FILENAME = ''' + @GroupFileLocation + @FileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
		SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     SIZE = ' + @FileSIZE + ', MAXSIZE = ' + @FileMAXSIZE + ',FILEGROWTH = ' + @FileFILEGROWTH + ' ) TO FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

		SET @SQL_IndexPartitionScheme = @SQL_IndexPartitionScheme + ',[' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';

		SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
		SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @IndexFileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
		SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     FILENAME = ''' + @IndexGroupFileLocation + @IndexFileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
		SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     SIZE = ' + @IndexFileSIZE + ', MAXSIZE = ' + @IndexFileMAXSIZE + ',FILEGROWTH = ' + @IndexFileFILEGROWTH + ' ) TO FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

	  END
	 
	  SET @SQL_PartitionFunction = @SQL_PartitionFunction + CAST(@CurrentRep_ID AS VARCHAR(20));

	  SET @NumOfFileGroup = @NumOfFileGroup + 1;
	  SET @SQL_PartitionScheme = @SQL_PartitionScheme + ',[' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';

	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @FileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     FILENAME = ''' + @GroupFileLocation + @FileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     SIZE = ' + @FileSIZE + ', MAXSIZE = ' + @FileMAXSIZE + ', FILEGROWTH = ' + @FileFILEGROWTH + ' ) TO FILEGROUP [' + @FileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

	  SET @SQL_IndexPartitionScheme = @SQL_IndexPartitionScheme + ',[' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + ']';

	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];';
	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE [' + @DatabaseName + '] ADD FILE (NAME = [' + @IndexFileLogicName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '],';
	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     FILENAME = ''' + @IndexGroupFileLocation + @IndexFileName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '.ndf'',';
	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     SIZE = ' + @IndexFileSIZE + ', MAXSIZE = ' + @IndexFileMAXSIZE + ', FILEGROWTH = ' + @IndexFileFILEGROWTH + ' ) TO FILEGROUP [' + @IndexFileGroupName + CAST(@NumOfFileGroup AS VARCHAR(10)) + '];'

	  SET @PrevioustRep_ID = @CurrentRep_ID;
	  
      FETCH NEXT FROM db_cursor INTO @CurrentRep_ID 
END 
CLOSE db_cursor  
DEALLOCATE db_cursor

SELECT 
    @PrimaryKeyFileGroupName = fg.name 
FROM sys.indexes i
	INNER JOIN sys.tables t ON i.object_id = t.object_id
	INNER JOIN sys.data_spaces ds ON i.data_space_id = ds.data_space_id
	INNER JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id
WHERE 
    t.name = 'B_MASTER_REPOSITORY_ITEM' AND i.is_primary_key = 1;

SELECT
    TOP 1 @PrimaryKeyConstraintName = kc.name
FROM sys.key_constraints kc
	INNER JOIN sys.index_columns ic ON kc.parent_object_id = ic.object_id AND kc.unique_index_id = ic.index_id
	INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	INNER JOIN sys.tables t ON kc.parent_object_id = t.object_id
WHERE 
    kc.type = 'PK' AND t.name = 'B_MASTER_REPOSITORY_ITEM';


SET @SQL_PartitionFunction = @SQL_PartitionFunction + ');' + @NewLine + 'GO' + @NewLine;
SET @SQL_PartitionScheme = @SQL_PartitionScheme + ');' + @NewLine + 'GO' + @NewLine;
SET @SQL_IndexPartitionScheme = @SQL_IndexPartitionScheme + ');' + @NewLine + 'GO' + @NewLine;

--SET @SQL_CreateClusteredIndex = @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ADD [Partition_Repo_ID] AS ISNULL([REPOSITORY_ID], -1) PERSISTED NOT NULL;';
SET @SQL_CreateClusteredIndex = @SQL_CreateClusteredIndex + @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] DROP CONSTRAINT [' + @PrimaryKeyConstraintName + '];' + @NewLine + 'GO' + @NewLine;
SET @SQL_CreateClusteredIndex = @SQL_CreateClusteredIndex + @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ADD  CONSTRAINT [' + @PrimaryKeyConstraintName + '] PRIMARY KEY NONCLUSTERED ([ITEM_ID]) ON [' + @PrimaryKeyFileGroupName + '];' + @NewLine + 'GO' + @NewLine;
SET @SQL_CreateClusteredIndex = @SQL_CreateClusteredIndex + @NewLine + 'CREATE CLUSTERED INDEX [B_MASTER_REP_ITEM_REPOSITORY_ID] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ([REPOSITORY_ID]) ON' +
                                ' [' + @PartitionSchemeName + ']([REPOSITORY_ID]);' + @NewLine + 'GO' + @NewLine;

PRINT  @NewLine +'/* Create FileGroup and File for data */'
PRINT  @SQL_FileGroup;
PRINT  @NewLine +'/* Create FileGroup and File for index */'
PRINT  @NewLine + @SQL_IndexFileGroup;
PRINT  @NewLine +'/* Create Parition Function and Partition Schema */'
PRINT  @NewLine + 'USE [' + @DatabaseName + ']' + @NewLine + 'GO';
PRINT  @NewLine + @SQL_PartitionFunction; 
PRINT  @NewLine + @SQL_PartitionScheme;
PRINT  @NewLine + @SQL_IndexPartitionScheme;
PRINT  @NewLine +'/* Re-create Primary Key as Non-Clustered and create a clustered index based on [REPOSITORY_ID] */'
PRINT  @NewLine + @SQL_CreateClusteredIndex;

SELECT
   @SQL_IndexPartition = string_agg(CHAR(13) + CHAR(10) + 'CREATE ' + [unique] + idx.[type_desc] + ' INDEX ' + QUOTENAME(index_name) + ' ON ' 
            + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(table_name) 
            + ' ( ' +  key_cols + ' )'
			+ CASE 
			     WHEN has_repoid_cols = 0 AND has_repoid_inc_cols = 0 THEN 
						CASE 
							WHEN inc_cols IS NULL THEN ' INCLUDE ( [REPOSITORY_ID] ) '
							ELSE ' INCLUDE ( ' + inc_cols + ',[REPOSITORY_ID] ) '
						END
				 ELSE isnull(' INCLUDE ( ' + inc_cols + ' ) ','') 
			  END
            --+ isnull(' INCLUDE ( ' + inc_cols + ' ) ','')
            + ' WITH (' + [options] + ' )'
            + ' ON ' + QUOTENAME(@IndexPartitionSchemeName) + '([REPOSITORY_ID]);' +  CHAR(13) + CHAR(10) + 'GO'
			, CHAR(13) + CHAR(10))
FROM sys.Indexes idx
    join sys.tables tbl
        on tbl.object_id = idx.object_ID
    join sys.stats stat
        ON  stat.object_id = idx.object_id
        AND stat.stats_id = idx.index_id
    JOIN sys.data_spaces dat
        ON  idx.data_space_id = dat.data_space_id
    cross apply (Select
        [Table_name] = OBJECT_NAME(idx.Object_ID)
    ,   [Table_object_ID] = idx.Object_ID
    ,   [Index_name] = idx.Name
    ,   [unique] = case when is_unique = 1 then 'UNIQUE ' else '' end

    ) labels
    cross apply (Select
        key_cols = string_agg( key_col_name + CASE when sub_ic.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END, ', ') collate DATABASE_DEFAULT
    ,   inc_cols = string_agg(inc_col_name + CASE when sub_ic.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END, ', ') collate DATABASE_DEFAULT
	,   has_repoid_cols = sum(case when upper(key_col_name) = 'REPOSITORY_ID' then 1 else 0 end)
	,   has_repoid_inc_cols = sum(case when upper(inc_col_name) = 'REPOSITORY_ID' then 1 else 0 end)
        from
            sys.index_columns sub_ic
            join sys.columns sub_col
                on sub_col.object_ID = sub_ic.object_id and sub_col.column_id = sub_ic.column_id
            cross apply (Select
                key_col_name = case when is_included_column = 0 then sub_col.name end
            ,   inc_col_name = case when is_included_column = 1 then sub_col.name end
            ) key_inc
        where sub_ic.object_id = idx.object_id and sub_ic.index_id = idx.index_id
            and is_included_column = 0
    ) cols
    cross apply (Select
        options = string_agg([option] + on_off, ', ')
        from (values
          ( 'PAD_INDEX = ' , idx.is_padded)
        , ( 'FILLFACTOR = ', nullif(idx.fill_factor, 0))
        , ( 'IGNORE_DUP_KEY = ', idx.ignore_dup_key)
        , ( 'STATISTICS_NORECOMPUTE = ', stat.no_recompute)
        , ( 'ALLOW_ROW_LOCKS = ', idx.allow_row_locks)
        , ( 'ALLOW_PAGE_LOCKS = ', idx.allow_page_locks)
		, ( 'DROP_EXISTING = ', 1)
        ) opts([option], val)
        cross apply (Select
            on_off = case val when 1 then 'ON' when 0 then 'OFF' else CONVERT( CHAR(5), val) end
        ) on_off_calc
    ) options_calc

where idx.name is not null and idx.is_primary_key = 0 and idx.type = 2
and [table_name] = 'B_MASTER_REPOSITORY_ITEM';

PRINT  @NewLine + '/* Re-Create non-clustered Indexes */'
PRINT @SQL_IndexPartition;

SET NOCOUNT OFF;



