
SET NOCOUNT ON;

DECLARE 
		 @DatabaseName VARCHAR(100) = 'epim'
        ,@GroupFileLocation VARCHAR(1000) = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\epim_data\' --Must End with "\"
		,@IndexGroupFileLocation VARCHAR(1000) = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\epim_data\' --Must End with "\"
		;
		/* RDS always has fixed GroupFileLocation: D:\rdsdbdata\DATA\  */
		 SET @GroupFileLocation = 'D:\rdsdbdata\DATA\';
		 SET @IndexGroupFileLocation = 'D:\rdsdbdata\DATA\';

/*** The Above parameters must be filled in accordingly ***/

/*** Below parameters are option ***/
DECLARE
        @TotalNumberOfPartitions INT = 10,  /* We can change it to larger number if needed */
		@FunctionName VARCHAR(100) = 'mHashPartition',
		@PartitionFuncFunctionName VARCHAR(100) = 'mHashPartitionFunction',
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
		@IndexPartitionSchemeName VARCHAR(100) = 'mIndexPartitionScheme',

		@PartitionKeyColumn VARCHAR(100) = 'PartitionKey';

/*** Do not change the parameters below ***/
DECLARE
		@CurrentFileGroupNumber INT = 1,
		@PrimaryKeyFileGroupName VARCHAR(50),
		@PrimaryKeyConstraintName VARCHAR(100),
		@NewLine VARCHAR(15) = CHAR(13) + CHAR(10),
		@SQL_Function VARCHAR(1000) = '',
		@SQL_PartitionFunction VARCHAR(1000) = '',
		@SQL_PartitionScheme VARCHAR(1000) = '',
		@SQL_FileGroup VARCHAR(MAX) = '',
		@SQL_IndexPartitionScheme VARCHAR(1000) = '',
		@SQL_IndexFileGroup VARCHAR(MAX) = '',
		@SQL_ReCreatePK VARCHAR(4000) = '',
		@SQL_IndexPartition VARCHAR(MAX) = '',
		@SQL_AddComputeColomn VARCHAR(1000) = '';

		SET @GroupFileLocation = TRIM(@GroupFileLocation);
		SET @GroupFileLocation = CASE WHEN RIGHT(@GroupFileLocation, 1) <> '\' AND RIGHT(@GroupFileLocation, 1) <> '/' THEN @GroupFileLocation + '\' ELSE @GroupFileLocation END;

		SET @IndexGroupFileLocation = TRIM(@IndexGroupFileLocation);
		SET @IndexGroupFileLocation = CASE WHEN RIGHT(@IndexGroupFileLocation, 1) <> '\' AND RIGHT(@IndexGroupFileLocation, 1) <> '/' THEN @IndexGroupFileLocation + '\' ELSE @IndexGroupFileLocation END;


SET @SQL_Function = 'CREATE FUNCTION [dbo].' + QUOTENAME(@FunctionName) + ' (@ID BIGINT)' + @NewLine +
                             ' RETURNS TINYINT' + @NewLine +
							 ' WITH SCHEMABINDING' + @NewLine +
							 ' AS' + @NewLine +
							 ' BEGIN' + @NewLine +
							 '       RETURN @ID % ' + CAST(@TotalNumberOfPartitions AS VARCHAR(10)) + ';' + @NewLine +
							 ' END;' + @NewLine  + 'GO' + @NewLine;
SET @SQL_PartitionFunction = 'CREATE PARTITION FUNCTION ' +QUOTENAME(@PartitionFuncFunctionName) + '(TINYINT)' + @NewLine +
                             '  AS RANGE LEFT FOR VALUES (';

SET @SQL_PartitionScheme = 'CREATE PARTITION SCHEME ' + QUOTENAME(@PartitionSchemeName)  + @NewLine +
                            ' AS PARTITION ' + QUOTENAME(@PartitionFuncFunctionName)  + @NewLine +
                            ' TO (';

SET @SQL_IndexPartitionScheme = 'CREATE PARTITION SCHEME ' + QUOTENAME(@IndexPartitionSchemeName)  + @NewLine +
                            ' AS PARTITION ' + QUOTENAME(@PartitionFuncFunctionName)  + @NewLine +
                            ' TO (';


WHILE @CurrentFileGroupNumber <=  @TotalNumberOfPartitions
BEGIN  

	  /* If it's NOT the first  */
	  IF (@CurrentFileGroupNumber > 1)
	  BEGIN
		IF @CurrentFileGroupNumber < @TotalNumberOfPartitions
		BEGIN
			SET @SQL_PartitionFunction = @SQL_PartitionFunction + ',';
		END;
		SET @SQL_PartitionScheme = @SQL_PartitionScheme + ',';
		SET @SQL_IndexPartitionScheme = @SQL_IndexPartitionScheme + ',';

	  END
	 
	  IF @CurrentFileGroupNumber < @TotalNumberOfPartitions
	  BEGIN
		SET @SQL_PartitionFunction = @SQL_PartitionFunction + CAST((@CurrentFileGroupNumber-1) AS VARCHAR(10));
	  END;

	  SET @SQL_PartitionScheme = @SQL_PartitionScheme + QUOTENAME(@FileGroupName + CAST(@CurrentFileGroupNumber AS VARCHAR(10)));

	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + ' ADD FILEGROUP ' + QUOTENAME(@FileGroupName + CAST(@CurrentFileGroupNumber AS VARCHAR(10))) + ';';
	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + 'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + ' ADD FILE (NAME = ' + QUOTENAME(@FileLogicName + CAST(@CurrentFileGroupNumber AS VARCHAR(10))) + ',';
	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     FILENAME = ''' + @GroupFileLocation + @FileName + CAST(@CurrentFileGroupNumber AS VARCHAR(10)) + '.ndf'',';
	  SET @SQL_FileGroup = @SQL_FileGroup + @NewLine + '     SIZE = ' + @FileSIZE + ', MAXSIZE = ' + @FileMAXSIZE + ', FILEGROWTH = ' + @FileFILEGROWTH + ' ) TO FILEGROUP ' + QUOTENAME(@FileGroupName + CAST(@CurrentFileGroupNumber AS VARCHAR(10))) + ';';

	  SET @SQL_IndexPartitionScheme = @SQL_IndexPartitionScheme + QUOTENAME(@IndexFileGroupName + CAST(@CurrentFileGroupNumber AS VARCHAR(10)));

	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + ' ADD FILEGROUP ' + QUOTENAME(@IndexFileGroupName + CAST(@CurrentFileGroupNumber AS VARCHAR(10))) + ';';
	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + 'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + ' ADD FILE (NAME = ' + QUOTENAME(@IndexFileLogicName + CAST(@CurrentFileGroupNumber AS VARCHAR(10))) + ',';
	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     FILENAME = ''' + @IndexGroupFileLocation + @IndexFileName + CAST(@CurrentFileGroupNumber AS VARCHAR(10)) + '.ndf'',';
	  SET @SQL_IndexFileGroup = @SQL_IndexFileGroup + @NewLine + '     SIZE = ' + @IndexFileSIZE + ', MAXSIZE = ' + @IndexFileMAXSIZE + ', FILEGROWTH = ' + @IndexFileFILEGROWTH + ' ) TO FILEGROUP ' + QUOTENAME(@IndexFileGroupName + CAST(@CurrentFileGroupNumber AS VARCHAR(10))) + ';';

      SET @CurrentFileGroupNumber = @CurrentFileGroupNumber + 1;
END 

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

SET @SQL_AddComputeColomn = 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ADD ' + QUOTENAME(@PartitionKeyColumn) + ' AS [dbo].' + QUOTENAME(@FunctionName) + '(ITEM_ID) PERSISTED NOT NULL;'+ @NewLine + 'GO' + @NewLine;

--SET @SQL_ReCreatePK = @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] DROP CONSTRAINT [' + @PrimaryKeyConstraintName + '];' + @NewLine + 'GO' + @NewLine + 
 --                               @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ADD  CONSTRAINT [' + @PrimaryKeyConstraintName + '] PRIMARY KEY CLUSTERED ([ITEM_ID]) ON ' + ' ' +QUOTENAME( @PartitionSchemeName) + '('  + QUOTENAME(@PartitionKeyColumn) + ');' + @NewLine + 'GO' + @NewLine;

IF (@PrimaryKeyFileGroupName IS NULL)
BEGIN
	 PRINT 'Error, @PrimaryKeyFileGroupName IS NULL, The table might already has Partition on it.';
	 RETURN;
END;

 SET @SQL_ReCreatePK = @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] DROP CONSTRAINT [' + @PrimaryKeyConstraintName + '];' + @NewLine + 'GO' + @NewLine + 
                                @NewLine + 'ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ADD  CONSTRAINT [' + @PrimaryKeyConstraintName + '] PRIMARY KEY NONCLUSTERED ([ITEM_ID]) ON ' + ' ' + QUOTENAME( @PrimaryKeyFileGroupName) + ';' + @NewLine + 'GO' + @NewLine;
SET @SQL_ReCreatePK = @SQL_ReCreatePK + @NewLine + 'CREATE CLUSTERED INDEX [B_MASTER_REP_ITEM_REPO_ID_CLUSTER] ON [dbo].[B_MASTER_REPOSITORY_ITEM]([REPOSITORY_ID])'  + ' ON ' +
                                QUOTENAME(@PartitionSchemeName) + '(' + QUOTENAME( @PartitionKeyColumn) + ');' + @NewLine + 'GO' + @NewLine;


PRINT  @NewLine +'/* Create FileGroup and File for data */'
PRINT  @SQL_FileGroup;
PRINT  @NewLine +'/* Create FileGroup and File for index */'
PRINT  @NewLine + @SQL_IndexFileGroup;
PRINT  @NewLine +'/* Create Parition Function and Partition Schema */'
PRINT  @NewLine + 'USE [' + @DatabaseName + ']' + @NewLine + 'GO';
PRINT  @NewLine + @SQL_Function; 
PRINT  @NewLine + @SQL_PartitionFunction; 
PRINT  @NewLine + @SQL_PartitionScheme;
PRINT  @NewLine + @SQL_IndexPartitionScheme;
PRINT  @NewLine +'/* Re-create Primary Key with Partition Schema binding */'
PRINT  @NewLine + @SQL_AddComputeColomn;
PRINT  @NewLine + @SQL_ReCreatePK;

SELECT
   @SQL_IndexPartition = string_agg(CHAR(13) + CHAR(10) + 'CREATE ' + [unique] + idx.[type_desc] + ' INDEX ' + QUOTENAME(index_name) + ' ON ' 
            + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(table_name) 
            + ' ( ' +  key_cols + ' )'
			+ CASE 
			     WHEN has_repoid_cols = 0 AND has_repoid_inc_cols = 0 THEN 
						CASE 
							WHEN inc_cols IS NULL THEN ' INCLUDE ( ' + QUOTENAME(@PartitionKeyColumn) +' ) '
							ELSE ' INCLUDE ( ' + inc_cols + ',' + QUOTENAME(@PartitionKeyColumn) +' ) '
						END
				 ELSE isnull(' INCLUDE ( ' + inc_cols + ' ) ','') 
			  END
            --+ isnull(' INCLUDE ( ' + inc_cols + ' ) ','')
            + ' WITH (' + [options] + ' )'
            + ' ON ' + QUOTENAME(@IndexPartitionSchemeName) + '(' + QUOTENAME(@PartitionKeyColumn) + ');' +  CHAR(13) + CHAR(10) + 'GO'
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
	,   has_repoid_cols = sum(case when upper(key_col_name) = @PartitionKeyColumn then 1 else 0 end)
	,   has_repoid_inc_cols = sum(case when upper(inc_col_name) = @PartitionKeyColumn then 1 else 0 end)
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



