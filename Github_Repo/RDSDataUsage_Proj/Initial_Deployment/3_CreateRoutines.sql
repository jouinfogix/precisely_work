USE [DataUsage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	CleanUp History Table
-- EXECUTE [dbo].[sp_CleanHistoryData] @ServerID = 1;
-- =============================================
CREATE PROCEDURE [dbo].[sp_CleanHistoryData] 
	@ServerID INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @NumOfDaysHistoryToKeep INT, @CutoffDate DATE;

	SELECT @NumOfDaysHistoryToKeep = [NumOfDaysHistoryToKeep] 
	FROM [dbo].[ConfigurationData] WHERE ServerID = @ServerID; 

	IF @NumOfDaysHistoryToKeep IS NULL OR @NumOfDaysHistoryToKeep < 1
	BEGIN
		RAISERROR(N'Invalid @ServerID passed in sp_CleanHistoryData.', 50000, 1);
	END

	SET @CutoffDate = DATEADD(DAY, (@NumOfDaysHistoryToKeep * -1), GETDATE());

	DELETE FROM [dbo].[TopTableInfoHistory] WHERE [DisplayDate] < @CutoffDate;
	DELETE FROM [dbo].[TableSizeChangeHistory] WHERE [DisplayDate] < @CutoffDate;
	DELETE FROM [dbo].[TableSizeHistory] WHERE [DisplayDate] < @CutoffDate;
	DELETE FROM [dbo].[ServerSizeHistory] WHERE [DisplayDate] < @CutoffDate;

	SET NOCOUNT OFF;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	Get Data From [dbo].[TableSizeHistory]
-- Example: [dbo].[sp_GetTopTableSize] @ServerID = 1, @StartDate=NULL, @EndDate = NULL
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetTopTableSize]
    @ServerID INT,
	@StartDate DateTime = NULL,
	@EndDate DateTime = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @MaxDate DATETIME, @TopRecordSelectCount INT;

	SELECT @TopRecordSelectCount = TopRecordSelectCount 
	FROM [dbo].[ConfigurationData] WHERE ServerID = @ServerID;

    IF @StartDate IS NULL
	BEGIN
		SET @StartDate = DATEADD(day, -7, GETDATE())  --'1900-01-01';
	END;

	    IF @EndDate IS NULL
	BEGIN
		SET @EndDate = GetDate();
	END;

	SET @StartDate = CAST(@StartDate AS DATE);
	SET @EndDate = CAST(@EndDate AS DATE);

	SELECT @MaxDate = DisplayDate FROM [dbo].[TableSizeHistory] TS
	WHERE 
	  TS.ServerID = ISNULL(@ServerID,  TS.ServerID) AND
	  TS.[DisplayDate] BETWEEN @StartDate AND @EndDate;

   WITH CTE_TopTables
   AS
   (
		SELECT TOP (@TopRecordSelectCount) SchemaName, TableName, ROW_NUMBER() OVER(ORDER BY [RowCount] DESC) AS RowOrder 
		FROM [dbo].[TableSizeHistory] TS
		WHERE TS.ServerID = ISNULL(@ServerID,  TS.ServerID) AND
	          TS.[DisplayDate] = @MaxDate
		ORDER BY TS.[RowCount] DESC
   )
	SELECT 
	SL.[ServerName],
	SS.[SchemaName] ,
	SS.[TableName] ,
	SS.[RowCount],
	SSPre.[RowCountChange] AS RowCountChange,
	SS.TotalSpaceMB AS TableTotalSpaceMB,
	SS.UsedSpaceMB AS TableUsedSpaceMB,
	SS.UnusedSpaceMB AS TableUnusedSpaceMB,
	SL.TotalSpaceGB AS ServerTotalSpaceGB,
	SL.PctFree AS ServerPctFree,
	SSPre.HasRetention AS HasRetention,
	CAST(TTIF.Min_UpdateTime AS DATE) AS Min_UpdateTime,
	SS.[DisplayDate]
	FROM [dbo].[TableSizeHistory] SS
	LEFT JOIN [dbo].[TableSizeChangeHistory] SSPre ON SS.[ServerID] = SSPre.[ServerID] AND  
	                 SS.[SchemaName] = SSPre.[SchemaName] AND
					 SS.[TableName] = SSPre.[TableName] AND
					 SS.[DisplayDate] =  SSPre.[DisplayDate]
	LEFT JOIN [dbo].[TopTableInfoHistory] TTIF ON SS.[ServerID] = TTIF.[ServerID] AND  
	                 SS.[SchemaName] = TTIF.[SchemaName] AND
					 SS.[TableName] = TTIF.[TableName] AND
					 SS.[DisplayDate] =  TTIF.[DisplayDate]
	INNER JOIN [dbo].[ServerList] SL ON SL.[ID] = SS.[ServerID]
	INNER JOIN CTE_TopTables TT ON TT.[TableName] = SS.[TableName]  AND 
	                               TT.[SchemaName] = SS.[SchemaName]
	WHERE 
	       SS.ServerID = @ServerID AND
	       SS.[RowCount] > 0 AND
	       SS.[DisplayDate]= @MaxDate
	ORDER BY SS.[ServerID], SS.[DisplayDate] DESC, TT.[RowOrder]

	SET NOCOUNT OFF;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	Process InterMediate Table
-- EXECUTE [dbo].[sp_PopulateIntermediateTableSize] @ServerID = 1;
-- =============================================
CREATE PROCEDURE [dbo].[sp_PopulateIntermediateTableSize]
	@ServerID INT
AS
BEGIN
SET NOCOUNT ON;

-- Insert statements for procedure here
DELETE FROM [dbo].[IntermediateTableSize];
	
WITH RowCount_CTE
AS(SELECT  SC.[name] AS SchemaName, 
OB.[name] AS TableName,  SUM (row_count) AS [RowCount]
FROM IAIGXDB.sys.dm_db_partition_stats S
   INNER JOIN IAIGXDB.sys.objects OB ON S.[object_id] = OB.[object_id]
   INNER JOIN IAIGXDB.sys.schemas SC ON SC.[schema_id] = OB.[schema_id]
WHERE (index_id=0 or index_id=1)
GROUP BY SC.[name], OB.[name]
),

 Size_CTE
AS(SELECT
    SC.[name] AS SchemaName,
    t.[NAME] AS TableName,
    SUM(a.total_pages) * 8 / 1024 AS TotalSpaceMB, 
    SUM(a.used_pages) * 8 / 1024 AS UsedSpaceMB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 / 1024 AS UnusedSpaceMB
FROM
    IAIGXDB.sys.tables t
INNER JOIN
    IAIGXDB.sys.partitions p ON t.object_id = p.OBJECT_ID
INNER JOIN
    IAIGXDB.sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN IAIGXDB.sys.schemas SC ON SC.[schema_id] = t.[schema_id]
GROUP BY SC.[name], t.[Name]
)

INSERT INTO [dbo].[IntermediateTableSize]
(
	ServerID
	,SchemaName
	,TableName
	,[RowCount]
	,TotalSpaceMB
	,UsedSpaceMB
	,UnusedSpaceMB
)
SELECT @ServerID AS ServerID, R.SchemaName, R.TableName, R.[RowCount], S.TotalSpaceMB, S.UsedSpaceMB, S.UnusedSpaceMB
FROM RowCount_CTE R 
INNER JOIN Size_CTE S ON R.TableName = S.TableName AND R.SchemaName = S.SchemaName

SET NOCOUNT OFF;
END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	Process Server Table
-- EXECUTE [dbo].[sp_ProcessAllDataUsage] @ServerID = 1;
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProcessAllDataUsage] 
	@ServerID INT
AS
BEGIN

	EXECUTE [dbo].[sp_CleanHistoryData] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_ProcessServerData] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_PopulateIntermediateTableSize] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_ProcessIntermediateData] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_ProcessTopTableInfo] @ServerID = @ServerID;
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	Process InterMediate Table
-- EXECUTE [dbo].[sp_ProcessIntermediateData] @ServerID = 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProcessIntermediateData] 
	@ServerID INT
AS
BEGIN

	DECLARE @CurrentDate DATE = GETDATE();

	DELETE FROM [dbo].[TableSizeHistory] 
	WHERE ServerID IN (SELECT ServerID FROM [dbo].[IntermediateTableSize]) AND [DisplayDate] = @CurrentDate;

	INSERT INTO [dbo].[TableSizeHistory] (
	[ServerID],
	[SchemaName],
	[TableName],
	[RowCount],
	TotalSpaceMB,
	UsedSpaceMB,
	UnusedSpaceMB,
	[DisplayDate]
	)
	SELECT
	[ServerID],
	[SchemaName],
	[TableName],
	[RowCount],
	TotalSpaceMB,
	UsedSpaceMB,
	UnusedSpaceMB,
	@CurrentDate AS DisplayDate
	FROM [dbo].[IntermediateTableSize];

	DELETE FROM [dbo].[ServerSizeHistory] 
	WHERE ServerID IN (SELECT ServerID FROM [dbo].[IntermediateTableSize]) AND [DisplayDate] = @CurrentDate;

	WITH Count_Tble ([ServerID], [RowCount])
	AS
	(
		SELECT [ServerID], 
		       SUM([RowCount]) AS [RowCount]
		FROM [dbo].[IntermediateTableSize]
		GROUP BY [ServerID]
	)
	INSERT INTO [dbo].[ServerSizeHistory] (
	[ServerID],
	[RowCount],
	[TotalSpaceGB],
	[FreeSpaceGB],
	[PctFree],
	[DisplayDate]
	)
	SELECT
	ITS.[ServerID],
	ITS.[RowCount],
	SL.[TotalSpaceGB],
	SL.[FreeSpaceGB],
	SL.[PctFree],
	@CurrentDate AS DisplayDate
	FROM [Count_Tble] ITS
	INNER JOIN [dbo].[ServerList] SL ON SL.ID = ITS.ServerID;

	DELETE FROM [dbo].[TableSizeChangeHistory] 
	WHERE ServerID IN (SELECT ServerID FROM [dbo].[IntermediateTableSize]) AND [DisplayDate] = @CurrentDate;

	WITH CTE AS
	(
		SELECT DisplayDate, RANK() OVER (ORDER BY DisplayDate DESC) AS RowNum
		FROM [dbo].[TableSizeHistory]
		GROUP BY DisplayDate
	
	)
	INSERT INTO [dbo].[TableSizeChangeHistory] (
	[ServerID] ,
	[SchemaName] ,
	[TableName],
	[RowCountChange],
	[DisplayDate])	
	SELECT T.ServerID, T.[SchemaName], T.TableName, T.[RowCount] - T2.[RowCount] AS RowCountChange, T.DisplayDate
	FROM [dbo].[TableSizeHistory] T
	  INNER JOIN [dbo].[TableSizeHistory] T2 
	  ON T.ServerID = T2.ServerID AND
		 T.TableName = T2.TableName  
	  INNER JOIN CTE T3 ON T3.DisplayDate = T2.DisplayDate
	WHERE  (T.[RowCount] - T2.[RowCount]) <> 0 AND
	       T.DisplayDate = @CurrentDate AND
			T3.RowNum = 2;

	UPDATE T
	SET [HasRetention] = 1
	FROM [dbo].[TableSizeChangeHistory] T
	WHERE T.DisplayDate = @CurrentDate AND
	      T.ServerID = @ServerID AND
	EXISTS(SELECT 1 FROM [dbo].[TableSizeChangeHistory] R 
	    WHERE R.RowCountChange < 0 AND
			  R.ServerID = T.ServerID AND
		      R.SchemaName = T.SchemaName AND
			  R.TableName = T.TableName);

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	Process Server Table
-- EXECUTE [dbo].[sp_ProcessServerData] @ServerID = 1;
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProcessServerData] 
	@ServerID INT
AS
BEGIN

	DECLARE @ServerName VARCHAR(100);
	
	SELECT TOP 1 @ServerName = ServerName FROM [dbo].[ConfigurationData]
	WHERE ServerID = @ServerID;

	IF @ServerName IS NULL
	BEGIN
		RAISERROR ( 'Can not find @ServerID',50000,1)
	END
	

	MERGE [dbo].[ServerList] AS Target
    USING (SELECT TOP 1
	  @ServerID AS ServerID
	, @ServerName AS ServerName
    ,TotalSpaceGB
    , FreeSpaceGB
    , PctFree
    FROM
    (SELECT DISTINCT
        SUBSTRING(dovs.volume_mount_point, 1, 10) AS Drive
    ,   CONVERT(INT, dovs.total_bytes / 1024.0 / 1024.0 / 1024.0) AS TotalSpaceGB
    ,   CONVERT(INT, dovs.available_bytes / 1048576.0) / 1024 AS FreeSpaceGB
    ,   CAST(ROUND(( CONVERT(FLOAT, dovs.available_bytes / 1048576.0) / CONVERT(FLOAT, dovs.total_bytes / 1024.0 /
                         1024.0) * 100 ), 2) AS NVARCHAR(50)) + '%' AS PctFree              
    FROM    sys.master_files AS mf
    CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.file_id) AS dovs) AS X)	AS Source

    ON Source.ServerID = Target.ID
    
    -- For Inserts
    WHEN NOT MATCHED BY Target THEN
        INSERT (ID
		,ServerName
		,TotalSpaceGB
		,FreeSpaceGB
		,PctFree) 
        VALUES (Source.ServerID,Source.ServerName, Source.TotalSpaceGB, Source.FreeSpaceGB, Source.PctFree)
    
    -- For Updates
    WHEN MATCHED THEN UPDATE SET
        Target.ServerName	= Source.ServerName,
        Target.TotalSpaceGB		= Source.TotalSpaceGB,
		Target.FreeSpaceGB		= Source.FreeSpaceGB,
		Target.PctFree		= Source.PctFree;

	

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Description:	Process Top Table info "MIN(UPDATETIME)"
-- EXECUTE [dbo].[sp_ProcessTopTableInfo] @ServerID = 1;
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProcessTopTableInfo] 
	@ServerID INT
AS
BEGIN
	DECLARE @TopRecordSelectCount INT, @LCount INT, @SchemaName VARCHAR(50), @TableName VARCHAR(100), @mSQL NVARCHAR(MAX);
	DECLARE @SourceDBName NVARCHAR(50) = 'IAIGXDB';
	DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE);

	SET NOCOUNT ON;

	SELECT @TopRecordSelectCount = TopRecordSelectCount 
	FROM [dbo].[ConfigurationData]
	WHERE ServerID = @ServerID;

	IF @TopRecordSelectCount < 1 OR @TopRecordSelectCount IS NULL
	BEGIN
		RAISERROR(N'Invalid @ServerID or @TopRecordSelectCount', 50001, 1); 
	END

	DELETE FROM [dbo].[TopTableInfoHistory] 
	WHERE ServerID IN (SELECT ServerID FROM [dbo].[IntermediateTableSize]) AND [DisplayDate] = @CurrentDate;


	DECLARE cur2 CURSOR FOR 
	SELECT TOP (@TopRecordSelectCount) SchemaName, TableName
	FROM [dbo].[TableSizeHistory]
	WHERE [DisplayDate] = @CurrentDate AND
	      [ServerID] = @ServerID AND
		  [TableName] LIKE 'UP_%'
	ORDER BY [RowCount] DESC

	OPEN cur2

	FETCH NEXT FROM cur2 into @SchemaName,@TableName

	WHILE @@FETCH_STATUS = 0   
	BEGIN

		SET @mSQL = N'INSERT INTO [dbo].[TopTableInfoHistory] ([ServerID],[Min_UpdateTime],[SchemaName],[TableName],[DisplayDate])'
		SET @mSQL = @mSQL + ' SELECT ' + CAST(@ServerID AS NVARCHAR(10)) + ' AS ServerID, MIN(UPDATETIME) AS MIN_UPDATETIME'
		SET @mSQL = @mSQL + ', ''' + CAST(@SchemaName AS NVARCHAR(100)) + ''' AS SchemaName'
		SET @mSQL = @mSQL + ', ''' + CAST(@TableName AS NVARCHAR(100)) + ''' AS TableName'
		SET @mSQL = @mSQL + ', ''' + CAST(@CurrentDate AS NVARCHAR(10)) + ''' AS DisplayDate'
		SET @mSQL = @mSQL + ' FROM [' + @SourceDBName + '].[' + @SchemaName + '].[' + @TableName + ']';
		
		EXECUTE sp_executesql @mSQL;

	FETCH NEXT FROM cur2 into @SchemaName,@TableName

	END

	CLOSE cur2
	DEALLOCATE cur2

	SET NOCOUNT OFF;
END
GO
