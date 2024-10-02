
/*

The SQL Scripts for Getting/Creating/Updating/Decommission Govern Environments.

Please note that I commented out all the Insert/Update/Delete statement, just in case run the script by unintended execution

*/

-- Community Database "D3S" on bzbdz2ikmp.database.windows.net
-- Login through SSMS by choosing Authentication method "Azure Active Directory - Universal with MFA".

USE D3S
GO


/********************************************
	Retrieve information about Govern environment
*********************************************/

-- Get Client information:
-- Table.Column [Client].[State]: @State = 0 (POC); @State=1 (Active); @State=2 (Inactive)
SELECT * FROM [dbo].[Client] WHERE Name LIKE '%Bunzl%';

-- Getting Company, Database and Url information by ClientID or UrlPrefix.
SELECT cds.[UrlPrefix], * FROM [dbo].[Company] cp INNER JOIN [dbo].[DatabaseServer] ds
ON ds.[ID] = cp.[DatabaseServerID]
INNER JOIN [dbo].[Client] cl ON cl.[ID] = cp.[ClientID]
LEFT JOIN [dbo].[CompanyDomainSetting] cds ON cds.[CompanyID] = cp.ID
WHERE cp.[ClientID] IN (191) 
--WHERE UrlPrefix like '%cpkcri2rueoqahvs%'
ORDER BY cp.ID, cds.UrlPrefix;

-- Getting SSO Endpoint information
SELECT DS.*, CDS.* 
FROM [dbo].[CompanyDomainSetting] CDS
INNER JOIN [dbo].[DomainSetting] DS ON CDS.[DomainSettingID] = DS.[ID]
INNER JOIN [dbo].[Company] CP ON CP.ID = CDS.CompanyID
INNER JOIN [dbo].[Client] CL ON CL.[ID] = cp.[ClientID]
WHERE cp.[ClientID] IN (15)
ORDER BY cp.ID, cds.UrlPrefix;

-- Getting DomainSetting Information
SELECT DS.*, CDS.*, DC.[Name] As IdpDomainCertificatename, 
DC.[File] AS IdpDomainCertificate, DC2.[Name] As SpDomainCertificatename, 
DC2.[File] AS SpDomainCertificate
FROM [dbo].[CompanyDomainSetting] CDS
INNER JOIN [dbo].[DomainSetting] DS ON CDS.[DomainSettingID] = DS.[ID]
INNER JOIN [dbo].[DomainCertificate] DC ON DC.[ID] = DS.IdpDomainCertificateID
INNER JOIN [dbo].[DomainCertificate] DC2 ON DC2.[ID] = DS.SpDomainCertificateID
WHERE CDS.CompanyID = 310;

-- Getting APIPublicKey and APIPrivateKey for Analyze Service Account
SELECT * FROM [dbo].[Resource] WHERE Email like '%analyze%@precisely.com' 

-- Getting Login/User Information
-- Table/Column [CompanyResource].[State]: Active State=1; Inactive State=2; Deleted State=3
SELECT UserName, C.*, LastLoggedInOn, R.Email
FROM [dbo].[CompanyResource] C 
INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID 
INNER JOIN Company CP on CP.ID = C.CompanyID
WHERE C.CompanyID in (1007) 
--and Email LIKE '%@Precisely.com%'
Order by 1

-- Find User 
SELECT * FROM [dbo].[Resource] 
WHERE [LastName] LIKE '%Ou%' AND FirstName LIKE '%Jingsong%';


/********************************************
	Create Govern environment
*********************************************/

SELECT * FROM [dbo].[Client] WHERE Name LIKE '%Bunzl%';

-------------------------------------
-- Insert table Client if not exists
-------------------------------------
 -- INSERT INTO [dbo].[Client]([Name], [State])
		VALUES('{Clientname}', 1);

-------------------------------------
-- Insert table Company
-------------------------------------
   -- @EnvironmentLevel: 0 = preview; 1 = Dev; 2 = UAT; 3 = Prod
   -- Find @DatabaseServerID
		SELECT * FROM [dbo].[DatabaseServer]
		WHERE Notes Like 'US%' AND EnvironmentLevel = 1;
		--WHERE Notes Like 'EU%' AND EnvironmentLevel = 1;
		--WHERE Notes Like 'UK%' AND EnvironmentLevel = 1;
		--WHERE Notes Like 'AU%' AND EnvironmentLevel = 1;
		--WHERE Notes Like 'S%' AND EnvironmentLevel = 1;

  -- @Priority AU=1, US=5; EU=2; UK=3
  -- LifecycleEndDate: For Training Environment: DATEADD(month, 6, getdate())  Else NULL
  
-- INSERT INTO [dbo].[Company] ([Status], DatabaseServerID, ClientID, EnvironmentLevel, Notes, [Name], [Priority], [LifecycleEndDate])
 	 VALUES('Inactive', @DatabaseServerID, @ClientID, @EnvironmentLevel, 'CSX-{JiraID} by {Assignee}', '{ClientName} Dev/UAT/Prod', @Priority, {LifecycleEndDate});

SELECT * FROM [dbo].[Company] ORDER BY ID DESC;

-------------------------------------
-- Insert table [CompanyDomainSetting] and URL
-------------------------------------
/*
@URL_Primary Dev Eample: 'hcsc.dev', 'hcsc-pcy.dev' and 'hcsc-forms.dev' 
@URL_Precisely UAT Eample: 'hcsc.uat', 'hcsc-pcy.uat' and 'hcsc-forms.uat'
@URL_Form Prod Eample: 'hcsc', 'hcsc-pcy' and 'hcsc-forms'
*/

/* Primary URL */
 -- INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    @CompanyID 
				 ,2
				 ,1
				 ,0
				 ,@URL_Primary 
				 ,1);

/* Precisely URL */
-- INSERT INTO [dbo].[CompanyDomainSetting](
			[CompanyID]
			,[DomainSettingID]
			,[AuthenticationType]
			,[AllowNewUserLogin]
			,[UrlPrefix]
			,[IsPrimary])
			VALUES(
				@CompanyID 
			 ,144
			 ,3
			 ,0
			 ,@URL_Precisely
			 ,0);

/* Form URL ONLY IF needed */
-- INSERT INTO [dbo].[CompanyDomainSetting](
			[CompanyID]
			,[DomainSettingID]
			,[AuthenticationType]
			,[AllowNewUserLogin]
			,[UrlPrefix]
			,[IsPrimary]) 
			VALUES(
			@CompanyID 
				,13
				,1
				,0
				,@URL_Form 
				,0);

-------------------------------------
-- Insert table [CompanyResource]
-------------------------------------

-- Find out your @myRourceID and Assignee @AssigneeResourceID
SELECT * FROM [dbo].[Resource] WHERE [email] IN ('jingsong.ou@precisely.com', 'stephen.linsley@precisely.com');

-- Please note that the ResourceID = 0 and 1 are hardcoded in, we need them for all the companies
--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@CompanyID , 0, 0, NULL, 2);
--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@CompanyID , 1, 1, NULL, 1);
--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
         VALUES(@CompanyID , @myRourceID, 1, NULL, 1);

--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@CompanyID,  @AssigneeResourceID, 1, NULL, 1);

-------------------------------------
-- Company the database from one of the template or existing datatabase
/*
Golden template is also standard template:
preview-golden-template
dev-golden-template
uat-golden-template
prod-golden-

Basic template usually for training site
preview-basic-template
dev-basic-template
uat-basic-template
prod-basic-template

For DIS:
dis-basic-template
dis-basic-prod-template
*/


-------------------------------------
-- Reset Image path and login table on Taget database (D3S_xxx)
-------------------------------------
/*
update sitenav set ImageIconUrl = null where ImageIconUrl like '%.menuicon.%';
update reporting.global_resource set UpdatedOn = '1/1/1900';
*/

-------------------------------------
-- Activate the company
 -- Wait for 10 minutes and login the environment.
-------------------------------------
 -- UPDATE [dbo].[Company] SET [Status] = 'Active' WHERE [ClientID] = {@ClienID} AND ID = {@CompanyID} AND [Status] ='Inactive';




 /********************************************
	Copy Govern environment
*********************************************/

-------------------------------------
-- De-activate the company
-------------------------------------

 -- UPDATE [dbo].[Company] SET [Status] = 'Inactive' WHERE [ClientID] = {@ClienID} AND ID = {@CompanyID} AND [Status] ='Active';

 -------------------------------------
-- Go to SSMS to rename the database as naming convention by adding yyymmdd at the end. 
-- For example: D3S_2222 to D3S_2222_20240130
-- The renamed database will be deleted after one month
-------------------------------------

-------------------------------------
-- Copy the database from template or existing database
-- Add the database to the same elastic pool as the original database
-- For Hyperscale the database, we should remove the origianl database out of the elastic pool first before adding the new database in
-------------------------------------

/*
If the Jira ticket requires to keep the work-flow, we might have to copy the users 
from source company to target company by running the following query.
*/


/**** For WorkFlow. If the user who created the workflow is not in the target database, after copying the environment, 
      the workfolow won't show unless we copied user as inactive state (state=2) for the target environment.
      Please note that this script ONLY copy the users belongs to the same ClientID!
      Please replace {SourceCompanyID} and {TargetCompanyID} before executing the script.
****/

Declare @SourceCompanyID INT = {SourceCompanyID}, 
@TargetCompanyID INT = {TargetCompanyID};

-- Uncomment the "INSERT statement below
-- INSERT INTO [dbo].[CompanyResource] (CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
SELECT @TargetCompanyID, CR.ResourceID, CR.IsAdministrator, NULL AS LastLoggedInOn, 2 AS [State]  
FROM [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] RS ON CR.ResourceID = RS.ID 
INNER JOIN [dbo].[Company] CP ON CP.ID = CR.CompanyID
INNER JOIN [dbo].[Client] CT on CT.ID = CP.ClientID
WHERE CR.CompanyID in (@SourceCompanyID) 
AND NOT EXISTS
(SELECT * FROM CompanyResource CR2 
WHERE CR2.CompanyID IN (@TargetCompanyID) AND CR.ResourceID = CR2.ResourceID)
AND EXISTS
(SELECT * FROM CompanyResource CR3 
INNER JOIN [dbo].[Company] CP3 ON CP3.ID = CR3.CompanyID
INNER JOIN [dbo].[Client] CT3 on CT3.ID = CP3.ClientID
WHERE CR3.CompanyID IN (@TargetCompanyID) AND CT3.ID = CT.ID);

-------------------------------------
-- Reset Image path and login table on Taget database (D3S_xxx)
-------------------------------------
/*
update sitenav set ImageIconUrl = null where ImageIconUrl like '%.menuicon.%';
update reporting.global_resource set UpdatedOn = '1/1/1900';
*/

-------------------------------------
-- Activate the company
-- Wait for 10 minutes and login the environment.
-------------------------------------
-- UPDATE [dbo].[Company] SET [Status] = 'Active' WHERE [ClientID] = {@ClienID} AND ID = {@CompanyID} AND [Status] ='Inactive';

 
  /********************************************
	Decommission Govern environment
*********************************************/

-------------------------------------
-- De-activate the company
-------------------------------------

 -- UPDATE [dbo].[Company] SET [Status] = 'Inactive' WHERE [ClientID] = {@ClienID} AND ID = {@CompanyID} AND [Status] ='Active';

  -------------------------------------
-- Go to SSMS to rename the database as naming convention by adding yyymmdd at the end. 
-- For example: D3S_2222 to D3S_2222_20240130
-- The renamed database will be deleted after one month
-------------------------------------

  /********************************************
	Add user to existing Govern environment
	We should ask the admin user to add new user from UI, 
	But sometimes we need to update the user status from non-active to active, we can also do it by SQL
*********************************************/

SELECT * FROM [dbo].[Resource] WHERE [email] IN ('stephen.linsley@precisely.com');

DECLARE @ResourceID INT = {Get from above statement}
,@CompanyID INT = {@CompanyID}
,@IsAdministrator INT = 1
,@State INT = 1  /*Active State=1; Inactive State=2; Deleted State=3*/

IF NOT EXISTS(SELECT * FROM [dbo].[CompanyResource] WHERE [CompanyID] = @CompanyID AND [ResourceID] = @ResourceID)
BEGIN
	INSERT INTO [dbo].[CompanyResource]([CompanyID], [ResourceID], [IsAdministrator], [LastLoggedInOn], [State])
			VALUES(@CompanyID, @ResourceID, @IsAdministrator, NULL, @State);
END
ELSE
BEGIN
	 UPDATE [dbo].[CompanyResource] SET [IsAdministrator] =@IsAdministrator, [State]=@State WHERE [CompanyID] = @CompanyID AND [ResourceID] = @ResourceID;
END

 /********************************************
	Change URL 
*********************************************/

-------------------------------------
-- De-activate the company
-------------------------------------

 -- UPDATE [dbo].[Company] SET [Status] = 'Inactive' WHERE [ClientID] = {@ClienID} AND ID = {@CompanyID} AND [Status] ='Active';

 -------------------------------------
-- Update URL 
-------------------------------------

SELECT [UrlPrefix], * FROM [dbo].[CompanyDomainSetting]  WHERE [CompanyID] = @CompanyID

-- UPDATE [dbo].[CompanyDomainSetting] SET [UrlPrefix] = '{New URL}' WHERE [CompanyID] = @CompanyID AND [UrlPrefix] = @CurrentUrlPrefix;

 -------------------------------------
-- Activate the company
-- Wait for 10 minutes and login the environment.
-------------------------------------
-- UPDATE [dbo].[Company] SET [Status] = 'Active' WHERE [ClientID] = {@ClienID} AND ID = {@CompanyID} AND [Status] ='Inactive';

/************************************
  How to remove URL but environment 
************************************/
1) First find out CompanyID and IsPrimary flag:

 SELECT cst.[UrlPrefix], cst.IsPrimary,  cst.[CompanyID]  FROM [dbo].[Company] cp 
LEFT JOIN [dbo].[CompanyDomainSetting] cst ON cst.[CompanyID] = cp.ID
WHERE EXISTS(SELECT 1 FROM [dbo].[CompanyDomainSetting] cds
             WHERE cds.[UrlPrefix] = 'bdp-forms' AND cds.CompanyID = cp.ID);

2) If the UrlPrefix you want to delete with IsPrimary = 0, then go ahead to delete it.

-- DELETE cst FROM [dbo].[CompanyDomainSetting] cst WHERE cst.[UrlPrefix] = 'bdp-forms' AND cst.CompanyID = 510;

3) If the UrlPrefix you want to delete with IsPrimary = 1, then you must first set IsPrimary to other URL, then delete it.

--UPDATE [dbo].[CompanyDomainSetting] SET IsPrimary = 1 WHERE [UrlPrefix] = 'bdp' AND CompanyID = 510;
--DELETE cst FROM [dbo].[CompanyDomainSetting] cst WHERE cst.[UrlPrefix] = 'bdp-forms' AND cst.CompanyID = 510;

  /********************************************
	Fix bug related to creating new Group due to missing Asset
*********************************************/

-- As of 07/15/2024, there is an issue on creating groups after create/clone environment.
-- DevOps team will fix it in a few months.
-- I'll have to run the following script before it's been fixed.


1) We MUST let the environment becomes active first and login to the environment to check if
   the users in table [reporting].[Global_Resource] contains all the users in community database:
   
   -- Check environment database:
   SELECT * FROM [reporting].[Global_Resource];

   -- Check community database:
   SELECT C.ResourceID,  C.CompanyID, R.email, C.[State] FROM [dbo].[CompanyResource] C INNER JOIN 
		[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in ({Environment Company ID});

2) Fix check environment database:
   IF(SELECT COUNT(1) AS cnt FROM [dbo].[Asset] AST 
         INNER JOIN [dbo].[AssetType] ATYPE ON AST.[AssetTypeID] = ATYPE.[ID]
          WHERE ATYPE.[Object] = 'ResourceType') 
	  =
     (SELECT COUNT(1) AS cnt FROM [reporting].[Global_Resource])
   BEGIN
	   PRINT 'Do NOT need to do anthing. Asset and Resource matches.';
   END
   ELSE
   BEGIN
	PRINT 'Have to go through next step to insert records in [Asset] table!';
   END;

3) Insert into [Asset]: 
   INSERT INTO [dbo].[Asset]
           ([AssetTypeID]
           ,[State]
           ,[Object]
           ,[ObjectID]
           ,[SourceID]
           ,[CreatedOn]
           ,[CreatedBy]
           ,[UpdatedOn]
           ,[UpdatedBy]
           ,[KeyHash]
           ,[FieldHash]
           ,[uid]
           ,[Code]
           ,[Color]
           ,[Icon])
	SELECT	ATYPE.[ID] as AssetTypeID,
			1 as [State],
			'Resource' as [Object],
			r.ResourceID as ObjectID,
			r.ResourceID as SourceID,
			r.CreatedOn,
			0 as CreatedBy,
			r.UpdatedOn,
			0 as UpdatedBy,
			null, null, r.Uid, null, null, null
	FROM	reporting.Global_Resource r
			left join [dbo].[Asset] a on a.ObjectID = r.ResourceID
			LEFT JOIN [dbo].[AssetType] ATYPE ON A.[AssetTypeID] = ATYPE.[ID]
	WHERE ATYPE.[Object] = 'ResourceType' AND a.ID is null;
