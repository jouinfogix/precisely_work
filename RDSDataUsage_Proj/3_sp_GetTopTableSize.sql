USE [DataUsage]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetTopTableSize]    Script Date: 9/19/2024 1:03:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Modified: 2024-09-01 Do not get info from TopTableInfoHistory and add LastRetentionDate
-- Description:	Get Data From [dbo].[TableSizeHistory]
-- Example: [dbo].[sp_GetTopTableSize] @ServerID = 1, @StartDate=NULL, @EndDate = NULL
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetTopTableSize]
    @ServerID INT,
	@StartDate DateTime = NULL,
	@EndDate DateTime = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @MaxDate DATETIME, @TopRecordSelectCount INT;

	SELECT @TopRecordSelectCount = TopRecordSelectCount 
	FROM [dbo].[ConfigurationData] WHERE ServerID = @ServerID;


	IF @StartDate IS NULL OR @EndDate IS NULL
	BEGIN
		SET @MaxDate = CAST(GetDate() AS DATE);
	END
	ELSE
	BEGIN
		IF @StartDate IS NULL
		BEGIN
			SET @StartDate = CAST(DATEADD(day, -7, GETDATE()) AS DATE)  --'1900-01-01';
		END;

	    IF @EndDate IS NULL
		BEGIN
			SET @EndDate = CAST(GetDate() AS DATE);
		END;

		SELECT @MaxDate = DisplayDate FROM [dbo].[TableSizeHistory] TS
		WHERE 
		TS.ServerID = ISNULL(@ServerID,  TS.ServerID) AND
		TS.[DisplayDate] BETWEEN @StartDate AND @EndDate;

	END;

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
	SSPre.LastRetentionDate AS LastRetentionDate,
	SS.[DisplayDate]
	FROM [dbo].[TableSizeHistory] SS
	LEFT JOIN [dbo].[TableSizeChangeHistory] SSPre ON SS.[ServerID] = SSPre.[ServerID] AND  
	                 SS.[SchemaName] = SSPre.[SchemaName] AND
					 SS.[TableName] = SSPre.[TableName] AND
					 SS.[DisplayDate] =  SSPre.[DisplayDate]
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

GRANT EXECUTE ON [dbo].[sp_GetTopTableSize] TO DBOperator
GO
