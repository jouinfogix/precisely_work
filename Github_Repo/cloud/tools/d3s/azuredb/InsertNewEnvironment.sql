
IF OBJECT_ID('InsertNewEnvironment', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[InsertNewEnvironment];
GO
 /*
	Created: 2018-02-19 By Sarath Thottempudi/Jingsong Ou
	Purpose: Create new client environment.
	Note:  
	       1. Read document: H:\Projects\P336 - Data3Sxity Govern\5-Documentation\SSO - Active Directory - Community Configuration.docx
	       2. This SP will not populate DatabaseServer
	       3. After running this SP, Copy the Client Environment database from template. 
		   4. After the client database is up. Update Company Status: UPDATE [dbo].[Company] SET Status = 'Active' WHERE ID = @CompanyID;
	       5. @DatabaseServerName and @DatabaseServerEventTopic must match the record in dbo.DatabaseServer
		   6. @IdpSsoEndpoint and @IdpSloEndpoint get from client
	Return: "EnvironmentID" as recordset.
	Example:

	EXECUTE [dbo].[InsertNewEnvironment]
	        @ClientName = 'TestClient2'
		   ,@DatabaseServerName = 'd3sdev.database.windows.net'
		   ,@DatabaseServerEventTopic = 'events-dev'
		   ,@EnvironmentLevelID = 1
		   ,@CompanyNotes = 'Test company note2'
		   ,@CompanyName = 'Test CompanyName2'
		   ,@PrimayDomainSettingID = 2
           ,@SecondaryDomainSettingID = 24
		   ,@IdpDomainCertificateName = 'Infogix Signing Certificate - 2018-21'
		   ,@SpDomainCertificateName = 'Infogix Signing Certificate - 2018-21'
		   ,@IdpSsoEndpoint = 'https://login.microsoftonline.com/42df87fc-485e-4626-b041-0747f9da6761/saml2'
		   ,@IdpSloEndpoint = 'https://login.microsoftonline.com/42df87fc-485e-4626-b041-0747f9da6761/saml2'
		   ,@PrimaryUrlPrefix = 'test.preview'  /* For preview site, URL must contains .preview */
		   ,@SecondaryUrlPrefix = 'test-igx.preview' /* For preview site, URL must contains .preview */
		   ,@ResourceID = 6412
		   ,@CompanyPriority = 5  /*
				 [dbo].[Company] SET [Priority] = 2 WHERE d.[Server] like 'eu.%'
				 [dbo].[Company] SET [Priority] = 5 WHERE d.[Server] like 'd3sus.%'      
				 [dbo].[Company] SET [Priority] = 2 WHERE d.[Server] like 'd3seu.%'
				 [dbo].[Company] SET [Priority] = 1 WHERE d.[Server] like 'prodau.%'
				 [dbo].[Company] SET [Priority] = 3 WHERE d.[Server] like 'd3sproduk.%'
				 [dbo].[Company] SET [Priority] = 5 WHERE d.[Server] like 'produs.%'
				 [dbo].[Company] SET [Priority] = 3 WHERE d.[Server] like 'produk.%'
				 [dbo].[Company] SET [Priority] = 4 WHERE d.[Server] like 'd3sprodeast.%'   
		                          */

 */
CREATE PROCEDURE [dbo].[InsertNewEnvironment]
  @ClientName NVARCHAR(500)
 ,@IsPoc BIT = 1   
 ,@DatabaseServerName VARCHAR(250) 
 ,@DatabaseServerEventTopic VARCHAR(250) /* events, events-dev, events-nightly and events-uat (For POC usually is events-nightly)*/
 ,@EnvironmentLevelID INT = 1     /* 0='NIGHTLY' (Preview); 1='CLIENTDEV'; 2='UAT'; 3='PROD'; 4='LEGACYDEV';  Please note POC doesn't mean it is Nightly!*/
 ,@CompanySynchAgentLog BIT = 0
 ,@CompanyNotes NVARCHAR(500) = NULL
 ,@CompanyName VARCHAR(250) = NULL
 ,@NeedSSO  BIT = 0
 ,@PrimayDomainSettingID INT = NULL         /* When @NeedSSO = 0 , need to get it from table [dbo].[DomainSetting] */
 ,@SecondaryDomainSettingID INT = NULL      /* When @NeedSSO = 0 , need to get it from table [dbo].[DomainSetting] */
 ,@IdpDomainCertificateName NVARCHAR(250) = NULL  /* Only required when @NeedSSO = 1 */
 ,@SpDomainCertificateName NVARCHAR(250) = NULL   /* Only required when @NeedSSO = 1 */
 ,@IdpSsoEndpoint VARCHAR(1000)    = NULL         /* Only required when @NeedSSO = 1 */
 ,@IdpSloEndpoint VARCHAR(1000)     = NULL        /* Only required when @NeedSSO = 1 */
 ,@DomainSettingHashAlgorithmType INT = 1         /* Only required when @NeedSSO = 1 */
 ,@DomainSettingSignInitialSSORequest BIT = 0     /* Only required when @NeedSSO = 1 */
 ,@PrimaryUrlPrefix NVARCHAR(50)  -- Example lmtom.preview  Please note POC should use xxx.preview!!!
 ,@SecondaryUrlPrefix NVARCHAR(50) -- Example lmtom-igx.preview
 ,@PriamryAllowNewUserLogin BIT = 0
 ,@SecondaryAllowNewUserLogin BIT = 1
 ,@ResourceID INT  /* your resource ID from table [Resource] table */
 ,@CompanyPriority INT = 5
AS
BEGIN
  DECLARE @ErrorSeverity_Parameter INT = 16
         ,@ErrorState_Parameter INT = 1
		 ,@PrimaryAuthenticationType INT = 1  /* CompanyDomainSetting attribute AuthenticationType 1 means Forms. and 2 means SSO */
		 ,@SecondaryAuthenticationType INT = 2 /* same description as @PrimaryAuthenticationType */
		 ,@ClientState BIT
		 ,@ErrorSeverity_Default INT = 16
		 ,@ErrorState_Default INT = 1
		 ;
  DECLARE @ClientID INT
         ,@EnvironmentID INT
		 ,@DatabaseServerID INT
		 ,@CompanyID INT
		 ,@IdpDomainCertificateID INT
		 ,@SpDomainCertificateID INT
		  ;

  DECLARE @EnvironmentLevels TABLE
			(
			  ID int, 
			  [Name] VARCHAR(50)
			);
  INSERT INTO @EnvironmentLevels (ID, [Name])  /* match the value in View [dbo].[ClientEnvironment] */
  VALUES(0, 'NIGHTLY'),(1, 'CLIENTDEV'),(2, 'UAT'),(3, 'PROD'),(4, 'LEGACYDEV');

  BEGIN TRY
    BEGIN TRANSACTION;

	    IF NOT EXISTS(SELECT 1 FROM @EnvironmentLevels WHERE ID = @EnvironmentLevelID)
		BEGIN
			RAISERROR('@EnvironmentLevelID is not predefined.', @ErrorSeverity_Parameter, @ErrorState_Parameter);
		END;

	    /*** Client Table ***/
		SET @ClientName = LTRIM(RTRIM(@ClientName));

		IF(LEN(@ClientName) = 0)
		BEGIN
			RAISERROR('@ClientName can not be empty.', @ErrorSeverity_Parameter, @ErrorState_Parameter);
		END;

		SELECT @ClientID = ID FROM [dbo].[Client] WHERE [Name] = @ClientName;

		IF(@ClientID IS NULL) -- NOT Exists
		BEGIN
		    SET @ClientState = 1
			IF(@IsPoc = 1)
			BEGIN
				SET @ClientState = 0   /* @ClientState = 0 (POC); @ClientState=1 (Active); @ClientState=2 (Inactive) */
			END;
			INSERT INTO [dbo].[Client]([Name], [State])
			VALUES(@ClientName, @ClientState);
			SET @ClientID = SCOPE_IDENTITY();
	    END;
		
		/*** DatabaseServer Table ***/

		SET @DatabaseServerName = LTRIM(RTRIM(@DatabaseServerName));
		SET @DatabaseServerEventTopic = LTRIM(RTRIM(@DatabaseServerEventTopic));


		SELECT @DatabaseServerID = ID FROM [dbo].[DatabaseServer] 
		WHERE [Server] = @DatabaseServerName AND [EventTopic] = @DatabaseServerEventTopic;

		IF(@DatabaseServerID IS NULL)
		BEGIN
			RAISERROR('DatabaseServerID is empty.', @ErrorSeverity_Parameter, @ErrorState_Parameter);
		END;

		/*** Company Table ***/

		SELECT @CompanyID = ID FROM [dbo].[Company] 
		WHERE DatabaseServerID = @DatabaseServerID AND SynchAgentLog = @CompanySynchAgentLog AND
		      ClientID = @ClientID AND EnvironmentLevel = @EnvironmentLevelID

		IF(@CompanyID IS NULL)
		BEGIN
			INSERT INTO [dbo].[Company] ([Status], DatabaseServerID, SynchAgentLog, ClientID, EnvironmentLevel, Notes, [Name], [Priority])
			VALUES('Inactive', @DatabaseServerID, @CompanySynchAgentLog, @ClientID, @EnvironmentLevelID, @CompanyNotes, @CompanyName, @CompanyPriority);
			SET @CompanyID = SCOPE_IDENTITY();
		END
		ELSE
		BEGIN
			UPDATE [dbo].[Company] SET Notes = @CompanyNotes, [Name] = @CompanyName WHERE ID = @CompanyID;
		END;

		SET @EnvironmentID = @CompanyID; /* check view [dbo].[ClientEnvironment] */


		/*** DomainSetting Table ***/

		IF(@NeedSSO = 1) /* only when SSO required we need to populate data for table [dbo].[DomainSetting] */
		BEGIN
			SELECT TOP 1 @PrimayDomainSettingID = ID FROM [dbo].[DomainSetting] WHERE IdpSsoEndpoint = '' AND IdpSloEndpoint = '' AND HashAlgorithmType = 1;

			SELECT @SecondaryDomainSettingID  = ID FROM [dbo].[DomainSetting] WHERE IdpSsoEndpoint = @IdpSsoEndpoint AND IdpSloEndpoint = @IdpSloEndpoint;

			IF(@SecondaryDomainSettingID IS NOT NULL)
			BEGIN
				SELECT @IdpDomainCertificateID = ID FROM [dbo].[DomainCertificate] WHERE [Name] = @IdpDomainCertificateName;
				SELECT @SpDomainCertificateID = ID FROM [dbo].[DomainCertificate] WHERE [Name] = @SpDomainCertificateName;

				INSERT INTO [dbo].[DomainSetting](
					 [IdpSsoEndpoint]
					,[IdpSloEndpoint]
					,[IdpDomainCertificateID]
					,[SpDomainCertificateID]
					,[HashAlgorithmType]
					,[SignInitialSSORequest])
				VALUES( 
					 @IdpSsoEndpoint
					,@IdpSloEndpoint
					,@IdpDomainCertificateID
					,@SpDomainCertificateID
					,@DomainSettingHashAlgorithmType
					,@DomainSettingSignInitialSSORequest);

				SET @SecondaryDomainSettingID = SCOPE_IDENTITY();
			END;
		END;

		/*** CompanyDomainSetting Table ***/
		
		IF(@PrimaryUrlPrefix = @SecondaryUrlPrefix OR 
		   EXISTS(SELECT 1 FROM [dbo].[CompanyDomainSetting] WHERE [UrlPrefix] IN (@PrimaryUrlPrefix, @SecondaryUrlPrefix)))
		BEGIN
		   RAISERROR('Can not have duplicated UrlPrefix in table [dbo].[CompanyDomainSetting]', @ErrorSeverity_Default, @ErrorSeverity_Default);
		END;

		IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanyDomainSetting] WHERE CompanyID = @CompanyID AND [UrlPrefix] = @PrimaryUrlPrefix ANd IsPrimary = 1)
		BEGIN
			INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			     @CompanyID
				 ,@PrimayDomainSettingID
				 ,@PrimaryAuthenticationType
				 ,@PriamryAllowNewUserLogin
				 ,@PrimaryUrlPrefix
				 ,1);
		END;

		IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanyDomainSetting] WHERE CompanyID = @CompanyID AND [UrlPrefix] = @SecondaryUrlPrefix ANd IsPrimary = 0)
		BEGIN
			INSERT INTO [dbo].[CompanyDomainSetting](
				[CompanyID]
				,[DomainSettingID]
				,[AuthenticationType]
				,[AllowNewUserLogin]
				,[UrlPrefix]
				,[IsPrimary]) 
			VALUES(
			     @CompanyID
				 ,@SecondaryDomainSettingID
				 ,@SecondaryAuthenticationType
				 ,@SecondaryAllowNewUserLogin
				 ,@SecondaryUrlPrefix
				 ,0);
		END;

		/*** CompanyResource Table  Active State=1; Inactive State=2; Deleted State=3;***/
		IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanyResource] WHERE CompanyID = @CompanyID AND [ResourceID] = 0)
		BEGIN
			INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@CompanyID, 0, 0, NULL, 1);
		END;
		IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanyResource] WHERE CompanyID = @CompanyID AND [ResourceID] = 1)
		BEGIN
			INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@CompanyID, 1, 1, NULL, 1);
		END;
		IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanyResource] WHERE CompanyID = @CompanyID AND [ResourceID] = @ResourceID)
		BEGIN
			INSERT INTO [dbo].[CompanyResource](CompanyID, ResourceID, IsAdministrator, LastLoggedInOn, [State])
			VALUES(@CompanyID, @ResourceID, 0, NULL, 1);
		END;

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
 
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
 
    SET @ErrorMessage = @ErrorMessage +  'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10)) + '.';
    SET @ErrorMessage = @ErrorMessage +  'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10)) + '.';
 
    SET @EnvironmentID = -1;
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

  SELECT @EnvironmentID AS EnvironmentID

END;
GO