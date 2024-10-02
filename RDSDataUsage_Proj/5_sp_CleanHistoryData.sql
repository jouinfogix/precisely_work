USE [DataUsage]
GO

/****** Object:  StoredProcedure [dbo].[sp_CleanHistoryData]    Script Date: 9/19/2024 1:02:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Modified: 2024-09-14 Do not need table TopTableInfoHistory
-- Description:	CleanUp History Table
-- EXECUTE [dbo].[sp_CleanHistoryData] @ServerID = 1;
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_CleanHistoryData] 
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

	-- DELETE FROM [dbo].[TopTableInfoHistory] WHERE [DisplayDate] < @CutoffDate;
	DELETE FROM [dbo].[TableSizeChangeHistory] WHERE [DisplayDate] < @CutoffDate;
	DELETE FROM [dbo].[TableSizeHistory] WHERE [DisplayDate] < @CutoffDate;
	DELETE FROM [dbo].[ServerSizeHistory] WHERE [DisplayDate] < @CutoffDate;

	SET NOCOUNT OFF;
END
GO

GRANT EXECUTE ON [dbo].[sp_CleanHistoryData] TO DBOperator
GO
