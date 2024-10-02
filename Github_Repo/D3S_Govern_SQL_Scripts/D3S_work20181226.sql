
/*

DIS workspaces are restricted from going into ClientPool* pools. Only Govern customers should be there. 
DIS workspaces can go into one of three pools starting with Hyperscale*. 
Internal, Precisely-specific environments go into InternalPool1. 

Hyperscale is a bit of a different beast than traditional SQL, from an architectural perspective. The limit on pools is 25 DBs.


*/


USE D3S
GO
return
145	Precisely
-- ClientID= 148	Charles River
-- ClientID=180	NZ Super Fund
-- ClientID=182	Hilltop Holdings
-- ClientID=145	Precisely
218	Home Partners of America


-- ClientID=187	Port of Antwerp
SELECT * FROM [dbo].[Client] WHERE Name LIKE '%Huntington Bank%';


SELECT * FROM [dbo].[Client] where ID in (200)

 -- @State = 0 (POC); @State=1 (Active); @State=2 (Inactive)
 -- INSERT INTO [dbo].[Client]([Name], [State])
		VALUES('NFR - Adsotech Scandinavia Oy', 1);
-- UPDATE [dbo].[Client] SET State = 0 WHERE ID = 56 and State=1;

/*
[dbo].[Company] SET [Priority] = 1 WHERE d.[Server] like 'd3sdevaus.%' or d.[Server] like 'prodau.%' 
[dbo].[Company] SET [Priority] = 1 WHERE d.[Server] like 'd3sdevaus.%' or d.[Server] like 'prodasia.%' 
[dbo].[Company] SET [Priority] = 2 WHERE d.[Server] like 'eu.%' or d.[Server] like 'd3seu.%';      
[dbo].[Company] SET [Priority] = 3 WHERE d.[Server] like 'd3sproduk.%' or d.[Server] like 'produk.%';
[dbo].[Company] SET [Priority] = 5 WHERE d.[Server] like 'produs.%' or d.[Server] like 'd3sus.%'   ;


*/

-- CompanyID =  348 Govern Model Demo
-- CompanyID =  350 connectorDevelopment
-- CompanyID =  377 European Commission POC
-- CompanyID =  377 European Commission POC
-- CompanyID =  386 Graybar Sandbox

-- FOR POC site, add LifecycleEndDate = DATEADD(month, 6, getdate())

  -- INSERT INTO [dbo].[Company] ([Status], DatabaseServerID, ClientID, EnvironmentLevel, Notes, [Name], [Priority], [LifecycleEndDate])
 	 VALUES('Inactive', 47, 200, 1, 'CSX-4137 by Parag Bansal Test2 ONLY', 'GIC Dev Test2', 5, DATEADD(day, 5, getdate()));

	   -- INSERT INTO [dbo].[Company] ([Status], DatabaseServerID, ClientID, EnvironmentLevel, Notes, [Name], [Priority], [LifecycleEndDate])
 	 VALUES('Inactive', 4, 148, 3, 'L3REQ-60671 by Syed Hussain', 'CharlesRiver c001-ALPHA Prod', 5, NULL);

--SELECT SCOPE_IDENTITY();

select * from Company where ID = 1037


select * from [dbo].[Company] where ID = 680 order by ID DESC

select * from dbo.Company where Name like '%Holding%' or Notes like '%Holding%';

select 2048 * 1.2

SELECT * FROM dbo.Company where ID = 745 ORDER BY ID DESC;

select Distinct DomainSettingID from Company CP inner join CompanyDomainSetting CDS 
on CDS.CompanyID = CP.ID

where CP. ClientID in (15, 145)

select * from CompanyDomainSetting where companyID = 951  and DomainSettingID = 246

select * from Company where DatabaseServerID = 30 ID = 951

select * from CompanyDomainGroup where companyID = 951  and DomainSettingID = 246

/* US */
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sus.database.windows.net');
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sprodeast.database.windows.net');
/* UK */
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sdevuk.database.windows.net') and EventTopic like '%dev%';
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sproduk.database.windows.net');
/* EU */
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3seu.database.windows.net') and EventTopic like '%dev%';;
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3seuprimary.database.windows.net');

/* AU */
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sdevaus.database.windows.net');
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sprodauseast.database.windows.net');

/* Singapore Uat */
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sdevasia.database.windows.net');
SELECT * FROM [dbo].[DatabaseServer] WHERE [Server] IN ( 'd3sprodasiasoutheast.database.windows.net');


SELECT * FROM [dbo].[DatabaseServer] WHERE Server like '%US%' OR [Notes] LIKE '%us%' OR Region like '%us%'


SELECT * FROM [dbo].[Company] WHERE ID = 406;

SELECT * FROM [dbo].[Company] WHERE NOtes LIKE '%CS-2998%'

SELECT c.*, ds.EventTopic, ds.[Server] FROM [dbo].[Company] c inner join dbo.DatabaseServer ds  
on ds.ID = c.DatabaseServerID WHERE c.DatabaseServerID in (14, 50) and c.EnvironmentLevel <> 1


SELECT * FROM [dbo].[Company] cp INNER JOIN dbo.DatabaseServer ds ON ds.ID = cp.DatabaseServerID 
WHERE cp.Status = 'Active' and ds.Server = 'd3sprodasiasoutheast.database.windows.net';

SELECT * FROM [dbo].[Company] cp INNER JOIN dbo.DatabaseServer ds ON ds.ID = cp.DatabaseServerID AND ds.ID = 38


SELECT cp.Priority, ds.Notes AS DB_Notes, cp.DatabaseServerID, * FROM [dbo].[Company] cp INNER JOIN dbo.DatabaseServer ds ON ds.ID = cp.DatabaseServerID 
WHERE ds.Server like '%EU%' ORDER BY DB_Notes;



/**********************************************************************/
-- Change Elia Dev database from d3sdevuk.database.windows.net to d3seu.database.windows.net

/**********************************************************************/
-- USE master
GO
--ALTER DATABASE [dbname] MODIFY NAME = [newdbname]

-- UPDATE [dbo].[Company] SET Status = 'Inactive' WHERE ClientID= 55 AND ID = 183 AND Status='Active';

-- UPDATE [dbo].[Company] SET [Status] = 'Inactive' WHERE [ClientID] = 214 AND ID in (985) AND [Status] ='Active';

-- UPDATE [dbo].[Company] SET [Status] = 'Inactive' WHERE [ClientID] = 55 AND ID IN 
(183) AND [Status] ='Active';

 -- UPDATE [dbo].[Company] SET [Status] = 'Active' WHERE [ClientID] = 214 AND ID in 
 (985) AND [Status] ='Inactive';
-- UPDATE [dbo].[Company] SET [Status] = 'Active' WHERE [ClientID] = 158 AND ID in (620) AND 
[Status] ='Inactive';

-- UPDATE [dbo].[Company] SET [Notes] = ISNULL([Notes], '') + ' - CS-2789 Remove.'  WHERE [ClientID] = 145 AND ID in () AND [Status] ='Inactive';

-- UPDATE [dbo].[Company] SET [Priority] = 1  WHERE [ClientID] = 145 AND ID in (520) --AND [Name] = 'Future Fund UAT';

--update CompanyDomainSetting Set AllowNewUserLogin = 1 where CompanyID = 1201 and UrlPrefix = 'c008-ALPHA';
--update CompanyDomainSetting Set AllowNewUserLogin = 1 where CompanyID = 1200 and UrlPrefix = 'c008-ALPHA.uat';

 select * from [dbo].[CompanyDomainSetting] where CompanyID = 803

 42
43

--UPDATE [dbo].[Company] SET [Priority] = 1  WHERE [ClientID] = 148 AND ID in (941);

SELECT * FROM [dbo].[Company] where ID = 941

--UPDATE [dbo].[Company] SET LifecycleEndDate = DATEADD(month, 6, getdate())  WHERE [ClientID] = 153 AND ID between 584 and 593;

SELECT * FROM [dbo].[Company] WHERE Notes LIKE '%JG%'  OR [Name] like '%JG%'
and ClientID = 153 and ID between 584 and 593

select * from Company where ID = 998


select * from Company cp  where 
cp.DatabaseServerID = 4  and cp.Status = 'Active'
cp.[Name] like '%workspace%' and cp.Status = 'Active'

select cds.[UrlPrefix], cds.CompanyID, * from  [dbo].[Company] cp 
INNER JOIN [dbo].[CompanyDomainSetting] cds
ON cds.[CompanyID] = cp.ID
WHERE cds.[UrlPrefix] like '%gicdis.uat%'

  SELECT cds.[UrlPrefix], * FROM [dbo].[Company] cp INNER JOIN [dbo].[DatabaseServer] ds
ON ds.[ID] = cp.[DatabaseServerID]
INNER JOIN [dbo].[Client] cl ON cl.[ID] = cp.[ClientID]
LEFT JOIN [dbo].[CompanyDomainSetting] cds ON cds.[CompanyID] = cp.ID
  --where cp.[ID] IN (1243);
WHERE cp.[ClientID] IN (78)  order by cp.ID 
WHERE cds.[UrlPrefix] like 'icis.dev'
order by cp.ID, cds.UrlPrefix

--Where cp.Notes like '%3551%'
order by ClientID, cp.ID

select * from Company where ID = 1042

select * from [dbo].[CompanyDomainSetting]  where CompanyID = 746 and UrlPrefix = 'c044-alpha-forms';

select * from [CompanyDomainSetting] where UrlPrefix = 'c001-alpha'


select * from [CompanyDomainSetting] where DomainSettingID = 144




--UPDATE [CompanyDomainSetting] SET DomainSettingID = 202, AuthenticationType = 3 where CompanyID = 1212 and UrlPrefix = 'c027-alpha.uat'



select * from [CompanyDomainSetting] where CompanyID = 1201 and UrlPrefix = 'c008-ALPHA'

--UPDATE [CompanyDomainSetting] SET DomainSettingID = 232, AuthenticationType = 3 where CompanyID = 1201 and UrlPrefix = 'c008-ALPHA'




select * from dbo.Company where ID = 412

select * from DomainSetting where ID = 202


--Replace the URL with the keycloak URL given and run it on the DB directly

select * from DomainSetting where ID  = 153
select * from DomainCertificate where ID = 86
SELECT * FROM [dbo].[CompanyDomainSetting] where DomainSettingID = 209;
select * from DomainSetting where IdpSsoEndpoint like '%whitecase.dev%'

select * from Company where ID in (720, 746)




select * from DomainSetting --where ID in (202);
where IdpSsoEndpoint like '%precisely%';

SELECT * FROM [dbo].[CompanyDomainSetting]  where CompanyID in (940) and UrlPrefix = 'esg-forms'
update[dbo].[CompanyDomainSetting]  SET UrlPrefix = 'esg-forms.dev'   where CompanyID in (940) and UrlPrefix = 'esg-forms'



select * from [CompanyDomainSetting] where CompanyID = 864



SELECT * FROM [dbo].[CompanyDomainSetting] where UrlPrefix is null

select * from DomainSetting where ID in ( 110, 143);

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'DomainSetting';

--INSERT INTO dbo.DomainSetting(
--IdpSsoEndpoint
--,IdpSloEndpoint
--,IdpDomainCertificateID
--,SpDomainCertificateID
--,HashAlgorithmType
--,SignInitialSSORequest
--,AuthenticationSettings
--)
--SELECT
--IdpSsoEndpoint
--,IdpSloEndpoint
--,IdpDomainCertificateID
--,SpDomainCertificateID
--,HashAlgorithmType
--,SignInitialSSORequest
--,AuthenticationSettings
--FROM dbo.DomainSetting WHERE ID = 110


SELECT * FROM [dbo].[CompanyDomainSetting]

 SELECT * FROM [dbo].[CompanyDomainSetting] WHERE CompanyID = 405 AND UrlPrefix in ( 'perrigo.dev', 'perrigo-igx.dev');


/******** clear image url for copying environment!!! 2020-06-25 ********/
--
--  update sitenav set ImageIconUrl = null where ImageIconUrl like '%.menuicon.%'
/******** sync user list ********/
-- update reporting.global_resource set UpdatedOn = '1/1/1900';


  /********************************************
	Fix bug related to creating new Group due to missing Asset
*********************************************/


/*************************************************************

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

*************************************************************/

/*****************
The search index will need to be rebuilt as well. This task can be started in two ways:

1. Through the UI: Go to Administration → Settings and click Rebuild Search Index located near the bottom in the Rebuild Requests tile
2.  OR Through the database: By inserting a record in the task queue table to create the same rebuild request:
-- INSERT INTO queue.task (Action, Custom, Date, Object, ObjectID) SELECT 'QueueRebuild', 'SearchIndex', DATEADD(MINUTE, 1, getdate()), 'Queue', 0;
****************/

--12/19/2022 Do not need to do the following query anymore! ----For Keycloak URL 2022-07-27 ON USER Database!!!
--INSERT INTO [dbo].[Setting]([ID],[Value])
VALUES(54
,'https://auth-stg.cloud.precisely.com/auth/realms/Precisely');


/***********************************
-- Delete BulkLoad information on target databae (after copying environment)
-- Login to Customer database like D3S_{CompanyID}
DELETE FROM [dbo].[load];
UPDATE [api].[Execution] set ApplicationID = '';
EXECUTE [api].[DeleteExecutionRecords] @numberOfDaysOlderThan = -2;

************************************/


SELECT * FROM [dbo].[Company] WHERE ID = 268;

 -- WHERE cp.[ClientID] IN (93);
 --WHERE EnvironmentLevel = 0;


-- SELECT * FROM [dbo].[CompanyDomainSetting] WHERE [UrlPrefix] LIKE '%whitecase%'

-- UPDATE [dbo].[CompanyDomainSetting] SET UrlPrefix = REPLACE(UrlPrefix, 'bradesco', 'santander') WHERE CompanyID = 261

SELECT * FROM [dbo].[CompanyDomainSetting] WHERE CompanyID = 215 AND DomainSettingID = 63

select UrlPrefix, * from [dbo].[CompanyDomainSetting] ORDER BY 1;

select * from [dbo].[CompanyDomainSetting] cds  where cds.UrlPrefix not like '%forms%'
and exists(select * from [dbo].[CompanyDomainSetting] cds2 where cds.CompanyID = cds2.CompanyID and 
cds2.UrlPrefix like '%dev%' and cds2.UrlPrefix  like '%forms%')

select lower(UrlPrefix), * from [dbo].[CompanyDomainSetting] cds where companyID in (357);

select * from [dbo].[CompanyDomainSetting] cds where DomainSettingID in (13);

select * from [dbo].[CompanyDomainSetting] cds where DomainSettingID not in (2, 24) and UrlPrefix like '%forms%'

select * from Setting where ID in (26, 27, 55, 13);


select REPLACE(UrlPrefix, 'futurefundsandpit', 'futurefundsandbox'), 
* from [dbo].[CompanyDomainSetting] where UrlPrefix like '%futurefundsandpit%' and CompanyID = 507;

select * from [CompanyDomainSetting] where CompanyID = 720
--update [CompanyDomainSetting] SET UrlPrefix = 'c105-alpha' where CompanyID = 720


/*  


-- For only one URL:

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    522
				 ,24
				 ,2
				 ,1
				 ,'strategicservices.dev'
				 ,1);

-- For forms

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    183
				 ,2
				 ,1
				 ,0
				 ,'pfg-forms.uat' 
				 ,0);

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    522
				 ,24
				 ,2
				 ,0
				 ,'perrigotrain5-igx.dev' 
				 ,1);


*/

/*
INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    799
				 ,2
				 ,1
				 ,0
				 ,'perf2.preview' 
				 ,1);

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    877
				 ,13
				 ,1
				 ,0
				 ,'pfg-inventory-forms' 
				 ,0);

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    507
				 ,24
				 ,2
				 ,0
				 ,'futurefundsandpit-igx.dev' 
				 ,0);
*/

--INSERT INTO [dbo].[CompanyDomainSetting](
--				[CompanyID]
--				,[DomainSettingID]
--				,[AuthenticationType]
--				,[AllowNewUserLogin]
--				,[UrlPrefix]
--				,[IsPrimary]) 
--			VALUES(
--			    847
--				 ,2
--				 ,1
--				 ,0
--				 ,'charlesriver-sbxauto.dev' 
--				 ,1);

--INSERT INTO [dbo].[CompanyDomainSetting](
--				[CompanyID]
--				,[DomainSettingID]
--				,[AuthenticationType]
--				,[AllowNewUserLogin]
--				,[UrlPrefix]
--				,[IsPrimary]) 
--			VALUES(
--			     847
--				 ,24
--				 ,2
--				 ,0
--				 ,'charlesriver-sbxauto-igx.dev'
--				 ,0);

/*** For Precisely ***/

/* -- Only one URL site for Precisely
INSERT INTO [dbo].[CompanyDomainSetting](
[CompanyID]
,[DomainSettingID]
,[AuthenticationType]
,[AllowNewUserLogin]
,[UrlPrefix]
,[IsPrimary])
VALUES(
    1251
 ,144
 ,3
 ,1
 ,'gicpoc3-pcy.dev'
 ,1);
 */

/*
INSERT INTO [dbo].[CompanyDomainSetting](
[CompanyID]
,[DomainSettingID]
,[AuthenticationType]
,[AllowNewUserLogin]
,[UrlPrefix]
,[IsPrimary])
VALUES(
  1199
 ,2
 ,1
 ,0 
 ,'vontobelaipoc.dev'
 ,1);

INSERT INTO [dbo].[CompanyDomainSetting](
[CompanyID]
,[DomainSettingID]
,[AuthenticationType]
,[AllowNewUserLogin]
,[UrlPrefix]
,[IsPrimary])
VALUES(
  1199
 ,144
 ,3
 ,0
 ,'vontobelaipoc-pcy.dev'
 ,0);

 */



 /* form  Also need to add SSO site to Okta list!! */
 /*



 INSERT INTO [dbo].[CompanyDomainSetting](
[CompanyID]
,[DomainSettingID]
,[AuthenticationType]
,[AllowNewUserLogin]
,[UrlPrefix]
,[IsPrimary])
VALUES(
    1205 
 ,144
 ,3
 ,0
 ,'kpmgpoc-pcy.dev'
 ,0);

 INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    1241 
				 ,13
				 ,1
				 ,0
				 ,'kpmgpoc-forms.dev' 
				 ,0);

 INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    1241 
				 ,2
				 ,1
				 ,0
				 ,'c008-ALPHA.uat' 
				 ,1);

*/


--- Keycloak URI login
/*

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    1044
				 ,2
				 ,1
				 ,0
				 ,'whitecase' 
				 ,1);

 INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    1044
				 ,228
				 ,3
				 ,1
				 ,'whitecase-pcy' 
				 ,0);
*/

/********************/


SELECT * FROM [dbo].[CompanyDomainSetting] 
WHERE [UrlPrefix] in ( 'gtl-pcy.uat');



SELECT * FROM [dbo].[CompanyDomainSetting] 
--WHERE [UrlPrefix] like '%forms%'
WHERE [UrlPrefix] LIKE '%hershey%' 
--WHERE [UrlPrefix] IN ( 'icis.dev')
--WHERE [CompanyID] = 205;

select * from DomainSetting

select * from CompanyDomainSetting where DomainSettingID = 130

/* First find out the records in table */
SELECT * FROM [dbo].[CompanyDomainSetting] WHERE CompanyID = 409 AND [UrlPrefix] IN ('hersheys-sandbox-igx.dev', 'hersheys-sandbox-forms.dev');
/* Update the URL for both Primary and Seconday URL (and/or form URL if there is any  */
-- UPDATE [dbo].[CompanyDomainSetting]  SET UrlPrefix = 'hershey.dev' WHERE CompanyID = 409 AND UrlPrefix = 'hersheys.dev';
-- UPDATE [dbo].[CompanyDomainSetting]  SET UrlPrefix = 'hershey-forms.dev' WHERE CompanyID = 409 AND UrlPrefix = 'hersheys-forms.dev';
-- UPDATE [dbo].[CompanyDomainSetting]  SET UrlPrefix = 'hershey-igx.dev' WHERE CompanyID = 409 AND UrlPrefix = 'hersheys-igx.dev';




sp_help CompanyDomainSetting 
SELECT * FROM [dbo].[CompanyDomainSetting] 
WHERE  CompanyID IN (335);

select * from CompanyDomainSetting where companyID in (
select companyID from [dbo].[CompanyDomainSetting] group by companyID having count(*) > 2)

select * from CompanyDomainSetting where DomainSettingID = 136;

select * from CompanyDomainSetting where UrlPrefix = 'ricoh-igx.dev'

--INSERT INTO [dbo].[CompanyDomainSetting](
--				[CompanyID]
--				,[DomainSettingID]
--				,[AuthenticationType]
--				,[AllowNewUserLogin]
--				,[UrlPrefix]
--				,[IsPrimary]) 
--			VALUES(
--			    335
--				 ,2
--				 ,1
--				 ,0
--				 ,'ricoh.dev'
--				 ,0);


select * from DomainSetting where ID in ( 96, 136);

SELECT * FROM [dbo].[CompanyDomainSetting]  CDS inner join dbo.Company CP on CP.ID = CDS.CompanyID
WHERE [UrlPrefix] LIKE '%infogixinternaltraining%.dev%' 

SELECT * FROM [dbo].[Setting]
SELECT * FROM [dbo].[Resource] WHERE ID = 6671

SELECT DISTINCT FIRSTNAME FROM [dbo].[Resource] where LastName = 'ServiceAccount'

Mohammed Taboun
SELECT * FROM [dbo].[Resource] 
where firstname like '%Mohammed%' and lastname like '%Taboun%';


SELECT * FROM [dbo].[Resource] WHERE Email like 'analyze1123@precisely.com' 
SELECT * FROM [dbo].[Resource] WHERE Email like 'analyze1219@precisely.com';
SELECT * FROM [dbo].[Resource] WHERE Email like 'analyze618@precisely.com' 


SELECT * FROM [dbo].[Resource] WHERE Email like 'hkapadia@crd.com' OR Email like '%406@infogix.com' 
OR Email like '%395@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE Email like 'oisin.jansen@precisely.com' or Email like 'analyze35@infogix.com' 
or Email like 'analyze23@infogix.com' 

SELECT C.ResourceID,  C.CompanyID, R.email FROM [dbo].[CompanyResource] C INNER JOIN 
[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in (984) AND R.email = 'analyze983@precisely.com';



SELECT * FROM [dbo].[CompanyResource] C INNER JOIN 
[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in (1028)
and r.ID in (169451)



SELECT UserName, IsAdministrator, LastLoggedInOn, ResourceID FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID 
INNER JOIN Company CP on CP.ID = C.CompanyID
INNER JOIN Client CLT on CLT.ID = CP.ClientID
WHERE C.CompanyID in (1007) --and Email LIKE '%98%'
 --and r.ID in (98)
 Order by 1

-- INSERT INTO [dbo].[CompanyResource]
(CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State]) VALUES(39, 157051, 1, NULL, 1);

/******************************************************************************************************************/
/**** For WorkFlow. If the user who created the workflow is not in the target database, after copying the environment, the workfolow won't show ***/
/******************************************************************************************************************/
/*
Declare @SourceCompanyID INT = 297, 
@TargetCompanyID INT = 296 ;

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
*/

SELECT CR.CompanyID, CR.ResourceID, CR.IsAdministrator, NULL AS LastLoggedInOn, 2 AS [State]  
FROM CompanyResource CR INNER JOIN Resource RS ON CR.ResourceID = RS.ID 
INNER JOIN [dbo].[Company] CP ON CP.ID = CR.CompanyID
INNER JOIN [dbo].[Client] CT on CT.ID = CP.ClientID
WHERE CR.CompanyID in (297) 
AND NOT EXISTS
(SELECT * FROM CompanyResource CR2 
WHERE CR2.CompanyID in (296) AND CR.ResourceID = CR2.ResourceID)
AND EXISTS
(SELECT * FROM CompanyResource CR3 
INNER JOIN [dbo].[Company] CP3 ON CP3.ID = CR3.CompanyID
INNER JOIN [dbo].[Client] CT3 on CT3.ID = CP3.ClientID
WHERE CR3.CompanyID IN (296) AND CT3.ID = CT.ID);

/******************************************************************************************************************/
/*** CompanyResource Table  Active State=1; Inactive State=2; Deleted State=3;***/


/*
---------------------------------------
-- Created 2021-03-26 10:15 AM
--- Insert user infogixapi@infogix.com to each Production site.
--  For Usage Monitor on Govern Environment Licensing
---------------------------------------

DECLARE @ResourceID INT
SELECT TOP 1 @ResourceID = ID FROM [dbo].[Resource] WHERE Email = 'infogixapi@infogix.com';

INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
SELECT cmp.ID AS CompanyID, @ResourceID AS ResourceID, 1 AS IsAdministrator,  NULL AS LastLoggedInOn, 1 AS [State] 
FROM [dbo].[Company] cmp 
WHERE cmp.Status = 'Active' AND cmp.EnvironmentLevel = 3 AND
EXISTS(SELECT * FROM [dbo].[CompanyDomainSetting] cds 
       WHERE cds.UrlPrefix LIKE '%-igx' AND cds.CompanyID = cmp.ID) AND
NOT EXISTS(SELECT * FROM [dbo].[CompanyResource] C 
           INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID 
		   WHERE C.[ResourceID] = @ResourceID AND C.CompanyID = cmp.ID);
*/

SELECT * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE R.Email = 'infogixapi@infogix.com'; 


SELECT C.State, * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.ResourceID = R.ID AND R.Email = 'analyze98@infogix.com' AND C.State != 3

SELECT C.State, * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R 
ON C.ResourceID = R.ID WHERE R.Email LIKE '%@infogix.com' 
AND R.[FirstName] = 'Smitha' AND R.[LastName] = 'Nidagundi' and CompanyID in (230)

SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'vkishore@infogix.com'

SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE '%@infogix.com' AND [FirstName] like '%Tim%' AND [LastName] = 'Curtin';

SELECT * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID /* AND R.[Email] LIKE '%@infogix.com' */
AND R.[FirstName] = 'Shad' AND R.[LastName] = 'Durr' WHERE C.CompanyID IN( 610, 611) AND C.[State] != 3;


SELECT * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID 
WHERE /* C.CompanyID in (610, 611) and */ ResourceID = 167092


/***** 
-- Remove employee that no longer work in Infogix

Nuhiya Rafeeq 

SELECT * FROM [dbo].[Resource] WHERE [FirstName] = 'Nuhiya' AND [LastName] = 'Rafeeq';

SELECT * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID AND R.[Email] LIKE '%@infogix.com' 
AND R.[FirstName] = 'Nuhiya' AND R.[LastName] = 'Rafeeq' AND State <> 3;

DECLARE 
@FirstName NVARCHAR(100) = 'Nuhiya',
@LastName NVARCHAR(100) = 'Rafeeq',
@Email NVARCHAR(100) = 'nrafeeq@infogix.com';

UPDATE C Set C.[State] = 3 FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.[ResourceID] = R.ID AND R.[Email] LIKE '%@infogix.com' 
AND R.[FirstName] = @FirstName AND R.[LastName] = @LastName  WHERE C.[State] != 3;


UPDATE C Set C.[State] = 3 FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R 
ON C.[ResourceID] = R.ID AND R.[Email] = @Email WHERE C.[State] != 3;


*****/

select * from CompanyResource CR where CR.[State] = 3 

SELECT * FROM [dbo].[Resource] WHERE [email] like 'powerbi622@precisely.com'


SELECT * FROM [dbo].[Resource] WHERE [APIPrivateKey] LIKE '%6FiWvAWlb3ha52dfFSC7j%' OR [uid] LIKE '%6FiWvAWlb3ha52dfFSC7j%'

-- UPDATE  [dbo].[CompanyResource] SET State = 2, IsAdministrator = 1 WHERE CompanyID IN (689) AND ResourceID = 6412;

-- UPDATE  [dbo].[CompanyResource] SET State = 1, IsAdministrator = 1 WHERE CompanyID IN (404) AND ResourceID = 6548;

select * from [dbo].[CompanyResource] WHERE CompanyID IN (520) AND ResourceID = 6412;

SELECT * FROM [dbo].[Resource] WHERE [email] like '%71@infogix.com' or [email] like '%157@infogix.com' or [email] like '%166@infogix.com'
4597  4716
SELECT * FROM [dbo].[Resource] WHERE [email] like 'analyze863@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [email] like 'dqplus687@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [email] like 'jskeen@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [email] like '%dqplus365%'
SELECT * FROM [dbo].[Resource] WHERE [email] like '%DataDiscover%'
SELECT * FROM [dbo].[Resource] WHERE [email] like '%mmigration%'
SELECT * FROM [dbo].[Resource] WHERE [email] like 'stephen.linsley@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [lastName] like '%Pilkington%'

SELECT APIPublicKey, APIPrivateKey, email, LastName, FirstName, UserName, * FROM [dbo].[Resource] WHERE [email] like 'dqplus%@infogix.com' order by 3;
SELECT APIPublicKey, APIPrivateKey, email, LastName, FirstName, UserName, * FROM [dbo].[Resource] WHERE [email] like 'analyze%@infogix.com'  order by 3;
SELECT * FROM [dbo].[Resource] WHERE [email] like 'Shalaish.Koul@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Koul' and FirstName = 'Shalaish' AND [email] like '%@infogix.com'


SELECT email, APIPublicKey, APIPrivateKey FROM [dbo].[Resource] WHERE [email] in ( 'analyze363@infogix.com', 'analyze364@infogix.com', 'analyze365@infogix.com');


SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Kelly' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Pappas' and FirstName = 'Michael' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Ortmann' and FirstName = 'Michael' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Roepke' and FirstName = 'Sven' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Kelly' and FirstName = 'Andy' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Skeen' and FirstName = 'Julie' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Chane-Kive' and FirstName = 'JD' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Ou' and FirstName = 'Jingsong' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Reed' and FirstName = 'Christopher' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Hussain' and FirstName = 'Sadat' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Davids' and FirstName = 'Kenneth' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Sisolak' and FirstName = 'Mike' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'durrani' and FirstName = 'Shadman' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Linsley' and FirstName = 'Stephen' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Egan' and FirstName = 'Patrick' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Boardman' and FirstName = 'Keith' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Durrani' and FirstName = 'Shadman' AND [email] like '%@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Ahmed' and FirstName = 'Sadat' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Lim' and FirstName = 'Esther' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'morrow-mcbride' and FirstName = 'james' AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [LastName] = 'Hussain'  AND [email] like '%@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE FirstName = 'Jarrar' and  LastName = 'Zaidi'
SELECT * FROM [dbo].[Resource] WHERE LastName = 'Donnelly' and FirstName = 'JD';
SELECT * FROM [dbo].[Resource] WHERE LastName = 'Williams' and FirstName = 'Adrian';
SELECT * FROM [dbo].[Resource] WHERE LastName = 'Ellore' and FirstName = 'Shyam';
SELECT * FROM [dbo].[Resource] WHERE LastName = 'Holtzman' and FirstName = 'Andrew';
SELECT * FROM [dbo].[Resource] WHERE LastName = 'Reynolds' and FirstName = 'Robert';

SELECT * FROM [dbo].[Resource] WHERE LastName = 'Mitchell'  and email like '%precisely.com'
 Chetna Gupta and Mary Gilmartin
SELECT * FROM [dbo].[Resource] WHERE [email] like 'jou@infogix.com'
SELECT * FROM [dbo].[Resource] WHERE [email] like '%niilo.tiili@adsotech.com%'
Sadat Ahmed
SELECT * FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.ResourceID = R.ID
WHERE --R.[LastName] = 'Egan' and R.FirstName = 'Patrick' AND R.[email] like '%@Infogix.com'
--and 
CompanyID in (506)

-- UPDATE [dbo].[CompanyResource] SET [IsAdministrator] = 1 , [State] = 1 WHERE ResourceID = 6412 AND CompanyID = 260 AND [State] = 1;

SELECT * FROM [dbo].[Resource] WHERE Status = 'Inactive';

/********** Team member departure **********/
-- UPDATE C SET C.[State] = 1 FROM [dbo].[CompanyResource] C INNER JOIN [dbo].[Resource] R ON C.ResourceID = R.ID WHERE 
R.[LastName] = 'Jackson' and R.FirstName = 'Paul' AND R.[email] like '%@infogix.com' AND C.[State] <> 3;

-- UPDATE [dbo].[Resource] SET [Status] = 'Inactive' WHERE [LastName] = 'Howard' and FirstName = 'Brian' AND [email] like '%@infogix.com' AND [Status] = 'Active';

SELECT * FROM [dbo].[Resource] WHERE ID = 119010


SELECT * FROM [dbo].[CompanyResource] WHERE CompanyID IN (717) AND ResourceID =6412 ;

SELECT * FROM [dbo].[CompanyResource] WHERE  ResourceID =135326 ;
----INSERT INTO [dbo].[CompanyResource]
(CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State]) VALUES(620, 158149, 1, NULL, 1);

SELECT * FROM [dbo].[Resource] WHERE [email] LIKE '%1061@%'

SELECT * FROM [dbo].[CompanyResource] WHERE ResourceID IN (158149) and CompanyID IN (184);

SELECT * FROM [dbo].[CompanyResource] WHERE ResourceID IN ( 6412) and CompanyID IN (258, 260)

SELECT * FROM [dbo].[CompanyResource] WHERE CompanyID IN (60) AND ResourceID = 4657

SELECT UrlPrefix, * FROM [dbo].[CompanyResource] CR inner join Resource RS on RS.ID = CR.ResourceID
inner join Company CP on CP.ID = CR.CompanyID
inner join CompanyDomainSetting CDS on CP.ID = CDS.CompanyID
where CR.CompanyID in (1007) and RS.ID IN (177899
,158149
,173892
,164276
,178389
,158443
,155946
,164397
,152462
,178108
,178109)


/*UPDATE*/ CR SET CR.[State] = 1 FROM [dbo].[CompanyResource] CR inner join Resource RS on RS.ID = CR.ResourceID
inner join Company CP on CP.ID = CR.CompanyID
inner join CompanyDomainSetting CDS on CP.ID = CDS.CompanyID
where CR.CompanyID in (1007) and RS.ID IN (177899
,158149
,173892
,164276
,178389
,158443
,155946
,164397
,152462
,178108
,178109)


5956

SELECT * FROM dbo.

-- update [dbo].[CompanyResource] SET State = 1, IsAdministrator = 1 where CompanyId in (182) and ResourceID in (158149);


 -- UPDATE [dbo].[CompanyResource] SET IsAdministrator = 1 WHERE [CompanyID] IN (504, 505, 506) AND [ResourceID] = 6412 AND State = 1 AND IsAdministrator = 0;
 select * from Resource where ID = 6412
 -- UPDATE  [dbo].[Resource] set UpdatedOn = GETUTCDATE() where ID = 6412

 select * from  [dbo].[CompanyResource] where CompanyID in (689, 690) and resourceID =158149 ;
  select * from  [dbo].[CompanyResource] where CompanyID between 543 and 552

--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
--			VALUES(1250, 0, 0, NULL, 2);
--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
--			VALUES(1250, 1, 1, NULL, 1);
--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
--          VALUES(1250, 158149, 1, NULL, 1);


--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
--			VALUES(1241, 169383, 1, NULL, 1);

-- jingsong.ou@precisely.com = 158149
-- stephen.linsley@Precisely.com = 152185

--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(321, 6412, 1, NULL, 1);

/* sadat.ahmed@precisely.com = 155946 */
--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(842, 155946, 1, NULL, 1);

/* Esther.Lim@precisely.com = 151231 */
--INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(1212, 151231, 1, NULL, 1);

-- christopher.reed@precisely.com = 155979
--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(761, 155979, 1, NULL, 1);

-- Michael Ortmann	mike.ortmann@precisely.com = 158559
--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(792, 158559, 1, NULL, 1);

-- shadman.durrani@precisely.com = 157288
--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(1007, 158149, 1, NULL, 1);

-- 	jennifer.santos@precisely.com  = 160882

-- 155946	sadat.ahmed@precisely.com

--  syed.hussain@Precisely.com = 158325
157542	sven.roepke@precisely.com

--  INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(1164, 197348, 1, NULL, 1);

			158014
	SELECT * FROM [dbo].[CompanyResource] where CompanyID in (  951) and ResourceID = 6412
SELECT * FROM [dbo].[CompanyResource] where CompanyID in (689, 690) and ResourceID = 158149

SELECT * FROM [dbo].[CompanyResource] where CompanyID in (624) and ResourceID = 158393

SELECT * FROM [dbo].[CompanyResource] where ResourceID = 

select * from Resource where email in ('mary.gilmartin@precisely.com') 165840
select * from Resource where email in ('shyam.ellore@precisely.com')  157610
select * from Resource where email in ('chetna.gupta@precisely.com') 156987
select * from Resource where email in ('declan.kilker@Precisely.com') 167132
select * from Resource where email in ('andy.kelly@Precisely.com') 167133
select * from Resource where email in ('arya.abinash@precisely.com') 166309
select * from Resource where email in ('Dawid.Fraccaro@precisely.com') 169383
select * from Resource where email in ('bartlomiej.wlazlowski@goldenore.com')  197348
select * from Resource where email in ('dhanisha.harjal@precisely.com') 167017
select * from Resource where email like '%michael.pappas@precisely.com%' 154822
select * from Resource where email like 'syed.hussain@Precisely.com' 158325
select * from Resource where email like 'Esther.Lim@precisely.com'  151231
select * from Resource where email like 'jay.prasad@precisely.com' 
select * from Resource where email like 'eleonora.haraguchi@precisely.com'  172660
select * from Resource where email like 'Marco.Kopp@precisely.com'
select * from Resource where email like 'Eric.Hubert@precisely.com'
select * from Resource where email like 'laura.collier@precisely.com'
select * from Resource where email like 'Robert.Reynolds@precisely.com'
select * from Resource where email like 'jennifer.santos@precisely.com'
select * from Resource where email = 'Adrian.Williams@Precisely.com'

 -- INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(1042, 157604, 1, NULL, 1);

select * from Resource where id = 158325
 jddonnelly@infogix.com

select * from  [dbo].[CompanyResource] where ResourceID in (158325 ) and CompanyID in (754)
select * from  [dbo].[CompanyResource] where ResourceID in (158149 ) and CompanyID in (953)
SELECT * FROM [dbo].[CompanyResource] WHERE ResourceID IN (6412) and CompanyID IN (953);
SELECT * FROM [dbo].[CompanyResource] WHERE CompanyID IN (759);

--update [dbo].[CompanyResource] set IsAdministrator = 1, State=1 where ResourceID = 6412 and CompanyID = 321
--update [dbo].[CompanyResource] set IsAdministrator = 1, State=1 where ResourceID = 158149 and CompanyID = 623

--update [dbo].[CompanyResource] set IsAdministrator = 1, State=1 where ResourceID = 158325 and CompanyID = 754
/***********************************************
resynced customer DB and CompanyResource by running this on customer DB:

update reporting.global_resource set UpdatedOn = '1/1/1900'

************************************************/

select 1240 * 0.55

SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'chetna.gupta@precisely.com';
SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'dqplus98@infogix.com';


SELECT * FROM [dbo].[Resource] WHERE APIPrivateKey = 'ynDPs3pu$saQ-PfUrK4VB6OPk9brxmLC--NZuVP$ZciQsd2rzl'

SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'Ana-Maria.Badulescu@precisely.com';

SELECT * FROM [dbo].[CompanyResource] WHERE [ResourceID] = 5292;

SELECT * FROM [dbo].[CompanyResource] WHERE [companyID] = 226 ORDER BY [ResourceID];

SELECT * FROM [dbo].[CompanyResource] WHERE [ResourceID] = 135692;

SELECT * FROM [dbo].[CompanyResource] WHERE [CompanyID] IN (688) AND [ResourceID] = 158149
SELECT * FROM [dbo].[CompanyResource] WHERE [CompanyID] IN (398) AND [ResourceID] = 4657

SELECT * FROM [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON 
R.ID = CR.[ResourceID] WHERE [CompanyID] IN (717) and email = 'jshortis@infogix.com'

SELECT * FROM [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R 
ON R.ID = CR.[ResourceID] WHERE CR.CompanyID = 717  CR.[ResourceID] = 158394;


 -- INSERT INTO CompanyResource VALUES(283, 158325, 1, NULL, 1);

-- UPDATE CompanyResource SET IsAdministrator =1, State=1 WHERE companyID IN (283) AND resourceID = 158325

SELECT * FROM [dbo].[CompanyResource] WHERE [ResourceID] = 0 AND [IsAdministrator] = 1

-- UPDATE [dbo].[CompanyResource] SET [IsAdministrator] = 1 WHERE [CompanyID] = 541 AND [ResourceID]  = 6412  

/************ Company Setting For Golden Template ************/
 -- INSERT INTO dbo.CompanySetting (CompanyID, SettingID, [Value]) VALUES(385, 59, 'true'),(385, 61,'false');

SELECT * FROM Setting WHERE FieldName LIKE '%line%'
SELECT * FROM Setting WHERE [Description] LIKE '%line%'
SELECT * FROM dbo.CompanySetting  WHERE CompanyID IN ( 216, 348) AND SettingID= 70
SELECT * FROM dbo.CompanySetting  WHERE CompanyID IN ( 532)  AND SettingID IN (59, 61, 68, 70);



SELECT * FROM dbo.CompanySetting  CS INNER JOIN 
dbo.Setting ST ON ST.ID = CS.SettingID WHERE CS.CompanyID IN (297)

SELECT * FROM dbo.CompanySetting WHERE CompanyID = 172;

--INSERT INTO dbo.CompanySetting(CompanyID, SettingID, Value)
-- SELECT 110 AS CompanyID, SettingID, Value FROM dbo.CompanySetting  WHERE CompanyID IN (206)

SELECT * FROM dbo.CompanySetting CS
WHERE NOT EXISTS(SELECT 1 FROM dbo.CompanySetting CS2 
WHERE CS2.SettingID = CS.SettingID AND CS2.[Value] = CS.[Value] 
AND CS2.CompanyID = 296)
AND CS.CompanyID = 297
UNION
SELECT * FROM dbo.CompanySetting CS
WHERE NOT EXISTS(SELECT 1 FROM dbo.CompanySetting CS2 
WHERE CS2.SettingID = CS.SettingID AND CS2.[Value] = CS.[Value] 
AND CS2.CompanyID = 297)
AND CS.CompanyID = 296;

/** disable fusion */
--INSERT INTO dbo.CompanySetting
--(
--CompanyID,
--SettingID,
--Value
--)
--VALUES
--(
--38, -- CompanyID - int
--70, -- SettingID - int
--'false' -- Value - varchar(max)
--)


select * from CompanySetting where COmpanyID = 250;



-- Check Lineage setting
SELECT * FROM dbo.CompanySetting WHERE CompanyID IN (38) AND SettingID IN (46, 68);

-- INSERT INTO dbo.CompanySetting(CompanyID, SettingID, [Value])
SELECT 266 AS CompanyID, CS.SettingID, CS.Value FROM dbo.CompanySetting CS WHERE CS.CompanyID IN (48)
AND NOT EXISTS(SELECT * FROM dbo.CompanySetting CS2 WHERE CS2.SettingID = CS.SettingID AND CS2.CompanyID = 38)

SELECT CS.CompanyID, CS.SettingID, CS.Value FROM dbo.CompanySetting CS WHERE CS.CompanyID IN (206)
AND NOT EXISTS(SELECT * FROM dbo.CompanySetting CS2 WHERE CS2.SettingID = CS.SettingID AND CS2.CompanyID = 276 
AND CS2.[Value] = CS.[Value])
UNION
SELECT CS.CompanyID, CS.SettingID, CS.Value FROM dbo.CompanySetting CS WHERE CS.CompanyID IN (112)
AND NOT EXISTS(SELECT * FROM dbo.CompanySetting CS2 WHERE CS2.SettingID = CS.SettingID AND CS2.CompanyID = 206 
AND CS2.[Value] = CS.[Value])

SELECT * FROM dbo.Setting where ID = 6336

SELECT * FROM dbo.Setting where Name like '%config%' or Description like '%config%'

/**** Linear 2.0 setting (Should not be used except mass mutual). Use LineageVersion (68) instead */
/*** Linear 3.0 is Asset Browse ***/
--INSERT INTO dbo.CompanySetting
--(
--CompanyID,
--SettingID,
--Value
--)
--VALUES
--(
--73, -- CompanyID - int
--46, -- SettingID - int
--'false' -- Value - varchar(max)
--)


--UPDATE dbo.CompanySetting SET Value = 'true' WHERE CompanyID = 112 AND SettingID= 59
--UPDATE dbo.CompanySetting SET Value = 'false' WHERE CompanyID = 112 AND SettingID= 61
--UPDATE dbo.CompanySetting SET Value = '3' WHERE CompanyID = 89 AND SettingID= 68
--UPDATE dbo.CompanySetting SET Value = 'false' WHERE CompanyID = 89 AND SettingID= 70

/**** Linear v 3.0 setting */
/*** Linear 3.0 is Asset Browse (Do not need to add to companySetting for new environment) ***/
-- LineageVersion (68) = 3
-- FusionEnabled (70) = false

SELECT * FROM dbo.CompanySetting  
WHERE CompanyID IN (60) AND SettingID IN (68, 70) 
ORDER BY SETTINGID DESC;

--SELECT * FROM dbo.CompanySetting  CS WHERE CS.SettingID = 68 and CS.value = '3'
--AND NOT EXISTS(SELECT * FROM dbo.CompanySetting  CS2 WHERE CS2.SettingID = 70 and CS2.value = 'false' AND CS.CompanyID = CS2.CompanyID)

/* 
--- Please note: DO NOT need to insert the following 2 items any more. 04/21/2020 !!!!
IF EXISTS(SELECT 1 FROM dbo.CompanySetting WHERE CompanyID = {CompanyID} AND SettingID = 68)
BEGIN
 UPDATE dbo.CompanySetting SET [Value] = '3' WHERE CompanyID = {CompanyID} AND SettingID = 68;
END
ELSE
BEGIN
INSERT INTO dbo.CompanySetting
(
CompanyID,
SettingID,
Value
)
VALUES
(
{CompanyID}, -- CompanyID - int
68, -- SettingID - int
'3' -- Value - varchar(max)
);
END;

IF EXISTS(SELECT 1 FROM dbo.CompanySetting WHERE CompanyID = {CompanyID} AND SettingID = 70)
BEGIN
 UPDATE dbo.CompanySetting SET [Value] = 'false' WHERE CompanyID = {CompanyID} AND SettingID = 70;
END
ELSE
BEGIN
INSERT INTO dbo.CompanySetting
(
CompanyID,
SettingID,
Value
)
VALUES
(
{CompanyID}, -- CompanyID - int
70, -- SettingID - int
'false' -- Value - varchar(max)
);
END;

*/

--UPDATE dbo.CompanySetting SET VALUE = '3' WHERE CompanyID in (38) and SettingID  = 68 and Value = '1';
--UPDATE dbo.CompanySetting SET VALUE = 'false' WHERE CompanyID in (38) and SettingID  = 70 and Value = 'true';

SELECT * FROM dbo.Setting where ID in (68, 70);


SELECT CompanyID, SettingID, Value FROM dbo.CompanySetting WHERE CompanyID IN (38);

SELECT * FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.ResourceID
WHERE CompanyID IN (618) and R.ID = 158378;


--INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			--VALUES(563, 4649, 1, NULL, 1);



SELECT * FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.ResourceID
WHERE CR.CompanyID IN (998) AND CR.State IN (1)
AND NOT EXISTS(SELECT * FROM  [dbo].[CompanyResource] CR2 WHERE  CR2.State IN (1) AND CR2.CompanyID IN (38) AND CR2.ResourceID = CR.ResourceID);

SELECT * FROM  [dbo].[CompanyResource] CR INNER JOIN [dbo].[Resource] R ON R.ID = CR.ResourceID
WHERE CR.CompanyID IN (38) AND CR.State IN (1)
AND NOT EXISTS(SELECT * FROM  [dbo].[CompanyResource] CR2 WHERE  CR2.State IN (1) AND CR2.CompanyID IN (153) AND CR2.ResourceID = CR.ResourceID);

SELECT * FROM CompanySetting WHERE CompanyID = 15 AND SettingID IN (59, 61);

SELECT cds.[UrlPrefix], * FROM [dbo].[Company] cp 
INNER JOIN [dbo].[DatabaseServer] ds ON ds.ID = cp.DatabaseServerID
INNER JOIN [dbo].[Client] cl ON cl.ID = cp.ClientID
LEFT JOIN [dbo].[CompanyDomainSetting] cds ON cds.CompanyID = cp.ID 
 WHERE cp.ID IN (190 , 200, 204);


SELECT TOP (1000) [CompanyID]
     ,[ResourceID]
     ,[IsAdministrator]
     ,[LastLoggedInOn]
     ,[State]
 FROM [dbo].[CompanyResource] where CompanyID=233;


 SELECT * FROM dbo.Setting ST WHERE ST.FieldName = 'ShowFusionRules';

 SELECT * FROM dbo.CompanySetting CS INNER JOIN dbo.Setting ST ON ST.ID = CS.SettingID AND ST.FieldName = 'ShowFusionRules';

SELECT * FROM CompanyResource CR INNER JOIN Resource R ON R.ID = CR.ResourceID
WHERE R.email = 'analyze103@infogix.com'
--WHERE R.ApiPublicKey = 'CqMr97q4ZizumZ1TDfwp$QvPq'

select * from INFORMATION_SCHEMA.tables where table_name like '%resource%'

select * from DomainCertificate

-- Getting DomainSetting Information
SELECT DS.*, CDS.*, DC.[Name] As IdpDomainCertificatename, 
DC.[File] AS IdpDomainCertificate, DC2.[Name] As SpDomainCertificatename, 
DC2.[File] AS SpDomainCertificate
FROM [dbo].[CompanyDomainSetting] CDS
INNER JOIN [dbo].[DomainSetting] DS ON CDS.[DomainSettingID] = DS.[ID]
INNER JOIN [dbo].[DomainCertificate] DC ON DC.[ID] = DS.IdpDomainCertificateID
INNER JOIN [dbo].[DomainCertificate] DC2 ON DC2.[ID] = DS.SpDomainCertificateID
WHERE CDS.CompanyID = 310;


-----------------
Following code for adding administrator 

SELECT * FROM CompanyResource CR INNER JOIN Resource R ON R.ID = CR.ResourceID
WHERE /* CR.CompanyID IN(1001) AND */ R.ID in (158149) and State = 2

SELECT * FROM CompanyResource CR INNER JOIN Resource R ON R.ID = CR.ResourceID
WHERE CR.CompanyID IN(533) AND R.email ='upanda@infogix.com';


  SELECT cds.[UrlPrefix], * FROM [dbo].[Company] cp INNER JOIN [dbo].[DatabaseServer] ds
ON ds.[ID] = cp.[DatabaseServerID]
INNER JOIN [dbo].[Client] cl ON cl.[ID] = cp.[ClientID]
LEFT JOIN [dbo].[CompanyDomainSetting] cds ON cds.[CompanyID] = cp.ID 
WHERE cp.ID = 720
WHERE UrlPrefix like 'preciselytraining41.dev'

SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'jingsong.ou@precisely.com'  -- 158149
SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'syed.hussain@Precisely.com'  --158325
SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'jennifer.santos@precisely.com' 160882
SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'stephen.linsley@precisely.com'
SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'Dawid.Fraccaro@precisely.com'  -- 169383
SELECT * FROM [dbo].[Resource] WHERE [Email] LIKE 'jou@infogix.com' 6412
SELECT * FROM [dbo].[Resource] WHERE [LastName] like 'Fraccaro'


--DECLARE @ResourceID INT = 158149
--,@CompanyID INT = 297 ;

--IF NOT EXISTS(SELECT * FROM [dbo].[CompanyResource] WHERE [CompanyID] = @CompanyID AND [ResourceID] = @ResourceID)
--BEGIN
--	INSERT INTO [dbo].[CompanyResource]([CompanyID], [ResourceID], [IsAdministrator], [LastLoggedInOn], [State])
--			VALUES(@CompanyID, @ResourceID, 1, NULL, 1);
--	PRINT 'Inserted User';
--END
--ELSE
--BEGIN
--	UPDATE [dbo].[CompanyResource] SET [IsAdministrator] =1, [State]=1 WHERE [CompanyID] = @CompanyID AND [ResourceID] = @ResourceID;
--	PRINT 'Updated User';
--END

-----------------


--SELECT C.ResourceID,  C.CompanyID, R.email, C.[State] FROM [dbo].[CompanyResource] C INNER JOIN 
[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in (296) AND 
R.email in ('jingsong.ou@precisely.com', 'jennifer.santos@precisely.com', 'anoop.kumar@precisely.com');


SELECT C.*, R.email, R.* FROM [dbo].[CompanyResource] C INNER JOIN 
[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in (1061) 
AND NOT EXISTS(SELECT C2.*, R2.email FROM [dbo].[CompanyResource] C2 INNER JOIN 
[dbo].[Resource] R2 ON C2.[ResourceID] = R2.ID WHERE C2.CompanyID in (1250) AND R.ID = R2.ID )

SELECT C.*, R.email, R.LastName, R.FirstName FROM [dbo].[CompanyResource] C INNER JOIN 
[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in (620) 
AND NOT EXISTS(SELECT C2.*, R2.email FROM [dbo].[CompanyResource] C2 INNER JOIN 
[dbo].[Resource] R2 ON C2.[ResourceID] = R2.ID WHERE C2.CompanyID in (1061) AND R.ID = R2.ID )

select * from [dbo].[CompanyResource]
--INSERT INTO [dbo].[CompanyResource]
SELECT 1251 AS CompanyID, ResourceID, IsAdministrator, NULL AS LastLoggedInOn, State
FROM [dbo].[CompanyResource] C INNER JOIN 
[dbo].[Resource] R ON C.[ResourceID] = R.ID WHERE C.CompanyID in (1061) 

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









