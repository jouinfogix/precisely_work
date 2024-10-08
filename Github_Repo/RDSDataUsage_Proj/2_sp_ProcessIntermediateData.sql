
-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Modify: 2024-10-01 Add LastRetentionDate
-- Description:	Process InterMediate Table
-- EXECUTE [dbo].[sp_ProcessIntermediateData] @ServerID = 1
-- =============================================
ALTER PROCEDURE [dbo].[sp_ProcessIntermediateData] 
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

    WITH CTE_Retention AS
	(
		SELECT MAX([DisplayDate]) AS LastRetentionDate,
		       ServerID, SchemaName, TableName
		FROM [dbo].[TableSizeChangeHistory]
		WHERE RowCountChange < 0
		GROUP BY ServerID, SchemaName, TableName
	
	)
	UPDATE T
	SET T.[LastRetentionDate] = R.[LastRetentionDate]
	FROM [dbo].[TableSizeChangeHistory] T
	INNER JOIN [CTE_Retention] R ON R.ServerID = T.ServerID AND
		      R.SchemaName = T.SchemaName AND
			  R.TableName = T.TableName
	WHERE T.DisplayDate = @CurrentDate AND
	      T.ServerID = @ServerID;

END
GO

GRANT EXECUTE ON [dbo].[sp_ProcessIntermediateData] TO DBOperator
GO