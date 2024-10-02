
-------------------------------------------------

declare @name varchar(100),@count int = 1;
While @count <= 9
BEGIN
	SET @name = 'Huntington Bank Train' + cast(@count as varchar(10));
	
	print @name

	INSERT INTO [dbo].[Company] ([Status], DatabaseServerID, ClientID, EnvironmentLevel, Notes, [Name], [Priority], [LifecycleEndDate])
 	 VALUES('Inactive', 50, 82, 1, 'CSX-4116 by Jennifer Santos', @name, 1, DATEADD(month, 6, getdate()));
	 --VALUES('Inactive', 50, 82, 1, 'CSX-4116 by Jennifer Santos', @name, 1, '2024-08-18');


	SET @count = @count + 1
END;
GO

--------------------------------------------------
INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    543
				 ,2
				 ,1
				 ,0
				 ,'preciselytrain1-forms.dev' 
				 ,0);

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    543
				 ,24
				 ,2
				 ,1
				 ,'preciselytrain1.dev' 
				 ,1);

-----------------------

--select * from [CompanyDomainSetting] where [UrlPrefix] like '%entaintrain%'

declare @name varchar(100), @name2 varchar(100);
declare @companyID int = 1228,
        @count int = 1;
While @count <= 9
BEGIN
	SET @name = 'huntington Banktrain' + cast(@count as varchar(10)) + '-forms.dev'
	SET @name2 = 'bectrain' + cast(@count as varchar(10)) + '-pcy.dev' 
	print @name2
	print @companyID
	INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    @companyID
				 ,13
				 ,1
				 ,0
				 , @name 
				 ,1);

INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    @companyID
				 ,144
				 ,3
				 ,1
				 ,@name2
				 ,0);

	SET @companyID = @companyID + 1
	SET @count = @count + 1
END;
GO

--------------------------------------------------

declare @name varchar(100), @name2 varchar(100);
declare @companyID int = 1228,
        @count int = 1;
While @count <= 9
BEGIN
	SET @name = 'huntingtonbanktrain' + cast(@count as varchar(10)) + '-forms.dev'
	SET @name2 = 'huntingtonbank' + cast(@count as varchar(10)) + '.dev' 
	print @name2
	print @companyID
	INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    @companyID
				 ,13
				 ,1
				 ,0
				 , @name 
				 ,1);


INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			    @companyID
				 ,2
				 ,1
				 ,0
				 ,@name2
				 ,0);

	SET @companyID = @companyID + 1
	SET @count = @count + 1
END;
GO

--------------------------------------------
declare @userID int = 158149;   -- jingsong.ou@precisely.com  158149
declare @userID2 int = 160882
    -- 152185;  -- stephen.linsley@Precisely.com 
    -- 160882	jennifer.santos@precisely.com
	-- 157743	kenneth.davids@precisely.com
	-- 160882 jennifer.santos@precisely.com 
	-- 150635 yann.chane-kive@precisely.com
declare @companyID int = 1228,
        @count int = 1;
While @count <= 9
BEGIN
 INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@companyID, 0, 0, NULL, 2);
INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@companyID, 1, 1, NULL, 1);
INSERT INTO [CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@companyID, @userID, 1, NULL, 1);

INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@companyID, @userID2, 1, NULL, 1);

	print @companyID
	
	SET @companyID = @companyID + 1
	SET @count = @count + 1

END;


/************ URL *********/

declare @mcount int = 1,
        @mcompanyID int = 1228;

While @mcount <= 9
BEGIN

SET NOCOUNT ON;

SELECT 'https://' + cds.[UrlPrefix] + '.data3sixty.com' 
FROM [dbo].[Company] cp INNER JOIN [dbo].[DatabaseServer] ds 
ON ds.[ID] = cp.[DatabaseServerID]
INNER JOIN [dbo].[Client] cl ON cl.[ID] = cp.[ClientID]
LEFT JOIN [dbo].[CompanyDomainSetting] cds ON cds.[CompanyID] = cp.ID
 where cp.[ID] IN (@mcompanyID);

 SELECT DISTINCT
 CHAR(12) + CHAR(10) 
+ 'DBInstance:' + ds.[Server]
+ CHAR(12) + CHAR(10) 
+ 'DBname: D3S_' + CAST(cp.ID AS VARCHAR(10))
+ CHAR(12) + CHAR(10)  
+ 'analyze' + CAST(cp.ID AS VARCHAR(10)) + '@precisely.com'
+ CHAR(12) + CHAR(10) 
+ 'APIPublicKey: ' + CAST(RS.APIPublicKey AS VARCHAR(100))
+ CHAR(12) + CHAR(10) 
+ 'APIPrivateKey: ' + CAST(RS.APIPrivateKey AS VARCHAR(100))
FROM [dbo].[Company] cp INNER JOIN [dbo].[DatabaseServer] ds 
ON ds.[ID] = cp.[DatabaseServerID]
INNER JOIN [dbo].[Client] cl ON cl.[ID] = cp.[ClientID]
LEFT JOIN [dbo].[CompanyDomainSetting] cds ON cds.[CompanyID] = cp.ID
LEFT JOIN [dbo].CompanyResource CR on CR.CompanyID = cp.ID
LEFT JOIN dbo.[Resource] RS on RS.ID = CR.ResourceID 
      and RS.email = 'analyze' + CAST(cp.ID AS VARCHAR(10)) + '@precisely.com'
 where cp.[ID] IN (@mcompanyID) ;


	SET @mcount = @mcount + 1;
	SET @mcompanyID = @mcompanyID + 1
END;
GO