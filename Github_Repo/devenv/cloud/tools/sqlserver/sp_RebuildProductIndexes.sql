


IF OBJECT_ID('sp_RebuildProductIndexes', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[sp_RebuildProductIndexes];
GO
 /*
	Created: 2018-02-29 By Jingsong Ou
	Purpose: Rebuild indexes that has fragmentation
	Note:  
	       1. Only build indexes for dynamic tables.
	       2. 
	      
	Example:

	EXECUTE [dbo].[sp_RebuildProductIndexes]
	        @Fragment_Threshhold = 40
		   ,@TableNamePattern = 'UP_%'

 */
CREATE PROCEDURE [dbo].[sp_RebuildProductIndexes]
 @Fragment_Threshhold INT = 40           /* Rebuild index if fragmentation > % */
,@TableNamePattern VARCHAR(50) = 'UP_%' /*  Only do it for dynamic table */
AS 
BEGIN
DECLARE @SQLString NVARCHAR(4000), @IndexColumns NVARCHAR(2000), @IncludedIndexColumns NVARCHAR(2000)
        ,@IndexID INT, @TableID INT 

DECLARE TableIndexCursor CURSOR FOR 
SELECT DISTINCT T.object_id AS TableID, I.index_id as IndexID, 
        'CREATE ' + CASE WHEN I.is_unique = 1 THEN ' UNIQUE ' ELSE '' END +
        I.type_desc COLLATE DATABASE_DEFAULT + ' INDEX [' +
        I.name + '] ON [' + SCHEMA_NAME(T.schema_id) + '].[' + T.name + '] ' + 
		'{IndexColumns}' +
		'{IncludedIndexColumns}' +
        ISNULL(' WHERE ' + I.filter_definition, '') + 
        ' WITH (PAD_INDEX = ' + CASE WHEN I.is_padded = 1 THEN 'ON' ELSE 'OFF' END + 
        ', STATISTICS_NORECOMPUTE = ' + CASE WHEN ST.no_recompute = 0 THEN 'OFF' ELSE 'ON' END + 
        ', SORT_IN_TEMPDB = OFF' + 
        /*', FILLFACTOR = ' + CONVERT(VARCHAR(5), CASE WHEN I.fill_factor = 0 THEN 100 ELSE I.fill_factor END) + */
        ', IGNORE_DUP_KEY = ' + CASE WHEN I.ignore_dup_key = 1 THEN 'ON' ELSE 'OFF' END +      
        ', ONLINE = OFF' + 
        ', ALLOW_ROW_LOCKS = ' + CASE WHEN I.allow_row_locks = 1 THEN 'ON' ELSE 'OFF' END + 
        ', ALLOW_PAGE_LOCKS = ' + CASE WHEN I.allow_page_locks = 1 THEN 'ON' ELSE 'OFF' END + 
		', DROP_EXISTING = ON ' +
        ') ON [' + DS.name + ']' AS [CreateIndex]
FROM    sys.indexes I INNER JOIN        
        sys.tables T ON  T.object_id = I.object_id AND T.type = 'U' INNER JOIN       
        sys.stats ST ON  ST.object_id = I.object_id AND ST.stats_id = I.index_id INNER JOIN 
        sys.data_spaces DS ON  I.data_space_id = DS.data_space_id INNER JOIN 
        sys.filegroups FG ON  I.data_space_id = FG.data_space_id 
WHERE I.is_primary_key = 0 AND I.is_unique_constraint = 0 
      AND EXISTS(SELECT 1 
	             FROM  
	              sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
	              INNER JOIN sys.partitions pt on pt.object_id = indexstats.object_id
	              WHERE I.object_id = indexstats.object_id AND 
				       I.index_id = indexstats.index_id AND
					   indexstats.avg_fragmentation_in_percent > @Fragment_Threshhold AND 
					   indexstats.page_count > 100 AND
					   indexstats.index_type_desc <> 'HEAP')
      AND T.name LIKE @TableNamePattern

OPEN TableIndexCursor
FETCH NEXT FROM TableIndexCursor INTO @TableID, @IndexID, @SQLString
WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @IndexColumns = ''
	SELECT @IndexColumns = @IndexColumns + '[' + C.name + CASE WHEN IC.is_descending_key = 0 THEN '] ASC' ELSE '] DESC' END + ','
    FROM sys.index_columns IC INNER JOIN sys.columns C ON  IC.object_id = C.object_id  AND IC.column_id = C.column_id
	, sys.indexes II, sys.tables TT
    WHERE IC.is_included_column = 0 AND IC.object_id = II.object_id AND IC.index_id = II.index_id
			AND TT.object_id = II.object_id  AND TT.object_id = @TableID AND II.index_id = @IndexID
	ORDER BY II.name, IC.key_ordinal
    SET @IndexColumns = '(' + SUBSTRING(@IndexColumns, 1, LEN(@IndexColumns) -1) + ')';
	SET @SQLString = REPLACE(@SQLString, '{IndexColumns}', @IndexColumns);

	SET @IncludedIndexColumns = ''
	SELECT @IncludedIndexColumns = @IncludedIndexColumns + '[' + C.name + CASE WHEN IC.is_descending_key = 0 THEN '] ASC' ELSE '] DESC' END + ','
    FROM sys.index_columns IC INNER JOIN sys.columns C ON  IC.object_id = C.object_id  AND IC.column_id = C.column_id
	, sys.indexes II, sys.tables TT
    WHERE IC.is_included_column = 1 AND IC.object_id = II.object_id AND IC.index_id = II.index_id
			AND TT.object_id = II.object_id  AND TT.object_id = @TableID AND II.index_id = @IndexID
	ORDER BY II.name, IC.key_ordinal
	IF(@IncludedIndexColumns IS NOT NULL AND LEN(@IncludedIndexColumns) > 0)
	BEGIN
		SET @IncludedIndexColumns = ' INCLUDE (' + SUBSTRING(@IncludedIndexColumns, 1, LEN(@IncludedIndexColumns) -1) + ')';
		SET @SQLString = REPLACE(@SQLString, '{IncludedIndexColumns}', @IncludedIndexColumns);
	END
	ELSE
	BEGIN
		SET @SQLString = REPLACE(@SQLString, '{IncludedIndexColumns}', '');
	END;
	
     --SELECT  object_name(object_id) AS table_name, name AS index_name from sys.indexes WHERE index_id = @IndexID
	 --print @SQLString
	 EXECUTE sp_executesql @SQLString

    FETCH NEXT FROM TableIndexCursor INTO @TableID, @IndexID, @SQLString
END 

CLOSE TableIndexCursor  
DEALLOCATE TableIndexCursor 

END;
GO



