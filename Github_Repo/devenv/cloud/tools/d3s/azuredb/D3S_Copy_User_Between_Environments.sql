

/*

	This script for copying users from one environment to another. 
	Please make a copy of the database table [dbo].[CompanyResource] before copying.
	Backup table example: SELECT * INTO [dbo].[CompanyResource20190613] FROM [dbo].[CompanyResource];
	
	This script will NOT copy/modify the service account like analyze{CompanyId}@infogix.com and dqplus{CompanyId}@infogix.com

*/


--- Find out Exists in Target but in Source and will mark them deleted (CompanyResource.State=3) next.
DECLARE @State_Deleted INT = 3,
        @Delete_Original_User_InTarget BIT = 1,
		@SourceCompanyID INT = 0,  /* Fill in Source CompanyId */
        @TargetCompanyID INT = 0, /* Fill in Target CompanyId */
		@AnalyzeAccountSource VARCHAR(100),
		@AnalyzeAccountTarget VARCHAR(100),
		@AnalyzeDQPlusAccountSource VARCHAR(100),
		@AnalyzeDQPlusAccountTarget VARCHAR(100);

SET @AnalyzeAccountSource = 'analyze' + CAST(@SourceCompanyID AS VARCHAR(10)) + '@infogix.com';
SET @AnalyzeAccountTarget = 'analyze' + CAST(@TargetCompanyID AS VARCHAR(10)) + '@infogix.com';
SET @AnalyzeDQPlusAccountSource = 'dqplus' + CAST(@SourceCompanyID AS VARCHAR(10)) + '@infogix.com';
SET @AnalyzeDQPlusAccountTarget = 'dqplus' + CAST(@TargetCompanyID AS VARCHAR(10)) + '@infogix.com';

IF (@Delete_Original_User_InTarget = 1)
BEGIN
  UPDATE CR SET CR.[State] = @State_Deleted FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.[ResourceID]
  WHERE CR.[CompanyID] IN (@TargetCompanyID) AND CR.[State] <> @State_Deleted AND R.Email NOT IN (@AnalyzeAccountTarget, @AnalyzeDQPlusAccountTarget)
  AND NOT EXISTS(SELECT * FROM  [dbo].[CompanyResource] CR2 WHERE CR2.[CompanyID] IN ( @SourceCompanyID) AND CR2.[ResourceID] = CR.[ResourceID]);
END;

-- Set the  [State] and [IsAdministrator] and [LastLoggedInOn] in Target
UPDATE CR SET CR.[State] = CR2.[State], CR.[IsAdministrator] = CR2.[IsAdministrator], CR.[LastLoggedInOn] = CR2.[LastLoggedInOn] 
FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.[ResourceID]
INNER JOIN [dbo].[CompanyResource] CR2 ON CR2.[CompanyID] IN ( @SourceCompanyID) AND CR2.[ResourceID] = CR.ResourceID 
WHERE CR.[CompanyID] IN (@TargetCompanyID);

-- Insert records only exists in Source
INSERT INTO [dbo].[CompanyResource]([CompanyID], [ResourceID], [IsAdministrator], [LastLoggedInOn], [State])
SELECT @TargetCompanyID AS CompanyID, CR.ResourceID, CR.IsAdministrator, CR.LastLoggedInOn, CR.[State] 
FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.[ResourceID]
WHERE CR.[CompanyID] IN (@SourceCompanyID) AND R.Email NOT IN (@AnalyzeAccountSource, @AnalyzeDQPlusAccountSource)
AND NOT EXISTS(SELECT * FROM  [dbo].[CompanyResource] CR2 WHERE CR2.[CompanyID] IN ( @TargetCompanyID) AND CR2.[ResourceID] = CR.[ResourceID]);

-- Update Resource.UpdatedOn for API Users (accounts) that exists on both Source and Target and the CompanyState is different

UPDATE R SET R.[UpdatedOn] = getutcdate()
FROM [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R 
	  ON R.[ID] = CR.[ResourceID] AND CR.[CompanyID] = @TargetCompanyID		 
WHERE EXISTS
	  ( SELECT 1 FROM [dbo].[CompanyResource] SourceCR 
		INNER JOIN [dbo].[Resource] SourceR 
	     ON SourceR.[ID] = SourceCR.[ResourceID] AND SourceCR.[CompanyID] = @SourceCompanyID
		WHERE SourceR.[ID] = R.[ID] AND CR.[State] <> SourceCR.[State] );
 			   
-- Check if there is any user in Source but target company. Expect no record will return

SELECT CR.CompanyID, CR.ResourceID, CR.IsAdministrator, CR.LastLoggedInOn, CR.[State] 
FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.[ResourceID]
WHERE CR.[CompanyID] IN (@SourceCompanyID)
AND NOT EXISTS
(SELECT * FROM  [dbo].[CompanyResource] CR2 WHERE CR2.[CompanyID] IN ( @TargetCompanyID) AND CR2.[ResourceID] = CR.[ResourceID]  
   AND CR2.[IsAdministrator] = CR.[IsAdministrator]);
