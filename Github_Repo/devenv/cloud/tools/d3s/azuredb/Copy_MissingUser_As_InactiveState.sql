/******************************************************************************************************************/
/**** For WorkFlow. If the user who created the workflow is not in the target database, after copying the environment, 
      the workfolow won't show unless we copied user as inactive state (state=2) for the target environment.
      Please note that this script ONLY copy the users belongs to the same ClientID!
      Please replace {SourceCompanyID} and {TargetCompanyID} before executing the script.
****/
/******************************************************************************************************************/



Declare @SourceCompanyID INT = {SourceCompanyID}, 
@TargetCompanyID INT = {TargetCompanyID};

INSERT INTO [dbo].[CompanyResource] (CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
SELECT @TargetCompanyID, CR.ResourceID, CR.IsAdministrator, NULL AS LastLoggedInOn, CR.State AS [State]  
FROM [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] RS ON CR.ResourceID = RS.ID 
INNER JOIN [dbo].[Company] CP ON CP.ID = CR.CompanyID
INNER JOIN [dbo].[Client] CT on CT.ID = CP.ClientID
WHERE CR.CompanyID in (@SourceCompanyID) AND RS.LastName <> 'ServiceAccount' 
AND NOT EXISTS
(SELECT * FROM CompanyResource CR2 
WHERE CR2.CompanyID IN (@TargetCompanyID) AND CR.ResourceID = CR2.ResourceID)
AND EXISTS
(SELECT * FROM CompanyResource CR3 
INNER JOIN [dbo].[Company] CP3 ON CP3.ID = CR3.CompanyID
INNER JOIN [dbo].[Client] CT3 on CT3.ID = CP3.ClientID
WHERE CR3.CompanyID IN (@TargetCompanyID) AND CT3.ID = CT.ID);