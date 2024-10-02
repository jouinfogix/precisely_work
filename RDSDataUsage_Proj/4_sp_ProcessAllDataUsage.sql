USE [DataUsage]
GO

/****** Object:  StoredProcedure [dbo].[sp_ProcessAllDataUsage]    Script Date: 9/19/2024 1:00:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Jingsong Ou
-- Create date: 2024-04-01
-- Modify date: 2024-09-19  Do not populate MinUpdate info that takes long
-- Description:	Process Server Table
-- EXECUTE [dbo].[sp_ProcessAllDataUsage] @ServerID = 1;
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_ProcessAllDataUsage] 
	@ServerID INT
AS
BEGIN

	EXECUTE [dbo].[sp_CleanHistoryData] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_ProcessServerData] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_PopulateIntermediateTableSize] @ServerID = @ServerID;

	EXECUTE [dbo].[sp_ProcessIntermediateData] @ServerID = @ServerID;

	--EXECUTE [dbo].[sp_ProcessTopTableInfo] @ServerID = @ServerID;
END
GO


GRANT EXECUTE ON [dbo].[sp_ProcessAllDataUsage] TO DBOperator
GO