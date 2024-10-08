USE [master]
GO
/****** Object:  Database [D3S_All_Reports]    Script Date: 8/23/2018 4:03:43 PM ******/
CREATE DATABASE [D3S_All_Reports]
GO
ALTER DATABASE [D3S_All_Reports] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [D3S_All_Reports].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [D3S_All_Reports] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET ARITHABORT OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [D3S_All_Reports] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [D3S_All_Reports] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [D3S_All_Reports] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [D3S_All_Reports] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET  MULTI_USER 
GO
ALTER DATABASE [D3S_All_Reports] SET DB_CHAINING OFF 
GO
ALTER DATABASE [D3S_All_Reports] SET ENCRYPTION ON
GO
ALTER DATABASE [D3S_All_Reports] SET QUERY_STORE = ON
GO
ALTER DATABASE [D3S_All_Reports] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [D3S_All_Reports]
GO
ALTER DATABASE SCOPED CONFIGURATION SET DISABLE_BATCH_MODE_ADAPTIVE_JOINS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET DISABLE_BATCH_MODE_MEMORY_GRANT_FEEDBACK = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET DISABLE_INTERLEAVED_EXECUTION_TVF = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ELEVATE_ONLINE = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ELEVATE_RESUMABLE = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET ISOLATE_SECURITY_POLICY_CARDINALITY = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET OPTIMIZE_FOR_AD_HOC_WORKLOADS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET XTP_PROCEDURE_EXECUTION_STATISTICS = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET XTP_QUERY_EXECUTION_STATISTICS = OFF;
GO
USE [D3S_All_Reports]
GO
/****** Object:  DatabaseScopedCredential [https://ussqlaudit.blob.core.windows.net/sqldbauditlogs]    Script Date: 8/23/2018 4:03:44 PM ******/
USE [D3S_All_Reports]
CREATE DATABASE SCOPED CREDENTIAL [https://ussqlaudit.blob.core.windows.net/sqldbauditlogs] WITH IDENTITY = N'SHARED ACCESS SIGNATURE'
GO
/****** Object:  DatabaseScopedCredential [https://ussqlaudit.blob.core.windows.net/sqldbtdlogs]    Script Date: 8/23/2018 4:03:44 PM ******/
USE [D3S_All_Reports]
CREATE DATABASE SCOPED CREDENTIAL [https://ussqlaudit.blob.core.windows.net/sqldbtdlogs] WITH IDENTITY = N'SHARED ACCESS SIGNATURE'
GO
/****** Object:  User [report_reader]    Script Date: 8/23/2018 4:03:44 PM ******/
CREATE USER [report_reader] FOR LOGIN [report_reader] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [report_operator]    Script Date: 8/23/2018 4:03:44 PM ******/
CREATE USER [report_operator] FOR LOGIN [report_operator] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [report_reader]
GO
ALTER ROLE [db_owner] ADD MEMBER [report_operator]
GO
ALTER ROLE [db_datareader] ADD MEMBER [report_operator]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [report_operator]
GO
/****** Object:  Table [dbo].[ds_1380_1070_b0db3e_1283649643]    Script Date: 8/23/2018 4:03:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ds_1380_1070_b0db3e_1283649643](
	[objectid] [decimal](19, 0) NULL,
	[name] [text] NULL,
	[shortdescription] [text] NULL,
	[artifacttypename] [text] NULL,
	[artifacttypeid] [decimal](19, 0) NULL,
	[objecturi] [text] NULL,
	[object] [text] NULL,
	[maturitylevel] [text] NULL,
	[maturitylevel2] [text] NULL,
	[iskeyapplication] [varchar](5) NULL,
	[iskeyreport] [varchar](5) NULL,
	[enterprise] [text] NULL,
	[division] [text] NULL,
	[businessunit] [text] NULL,
	[function] [text] NULL,
	[subfunction] [text] NULL,
	[level5] [text] NULL,
	[level6] [text] NULL,
	[level7] [text] NULL,
	[objectscore] [decimal](38, 10) NULL,
	[effectivedate] [varchar](100) NULL,
	[dss_workid] [text] NULL,
	[dss_id] [decimal](38, 10) NOT NULL,
	[dss_loadtimestamp] [varchar](100) NULL,
	[dss_processtimestamp] [varchar](100) NULL,
 CONSTRAINT [ds_1380_1070_b0db3e_1283649_PK] PRIMARY KEY CLUSTERED 
(
	[dss_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ds_1380_1120_b0db3e_1592993029]    Script Date: 8/23/2018 4:03:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ds_1380_1120_b0db3e_1592993029](
	[objectid] [decimal](19, 0) NULL,
	[name] [text] NULL,
	[shortdescription] [text] NULL,
	[artifacttypename] [text] NULL,
	[artifacttypeid] [decimal](19, 0) NULL,
	[objecturi] [text] NULL,
	[object] [text] NULL,
	[maturitylevel] [text] NULL,
	[maturitylevel2] [text] NULL,
	[iskeyapplication] [varchar](5) NULL,
	[iskeyreport] [varchar](5) NULL,
	[enterprise] [text] NULL,
	[division] [text] NULL,
	[businessunit] [text] NULL,
	[function] [text] NULL,
	[subfunction] [text] NULL,
	[level5] [text] NULL,
	[level6] [text] NULL,
	[level7] [text] NULL,
	[objectscore] [decimal](38, 10) NULL,
	[effectivedate] [varchar](100) NULL,
	[dss_workid] [text] NULL,
	[dss_id] [decimal](38, 10) NOT NULL,
	[dss_loadtimestamp] [varchar](100) NULL,
	[dss_processtimestamp] [varchar](100) NULL,
 CONSTRAINT [ds_1380_1120_b0db3e_1592993029_PK] PRIMARY KEY CLUSTERED 
(
	[dss_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ds_1380_1141_b0db3e_1579871270]    Script Date: 8/23/2018 4:03:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ds_1380_1141_b0db3e_1579871270](
	[objectid] [decimal](19, 0) NULL,
	[name] [text] NULL,
	[shortdescription] [text] NULL,
	[artifacttypename] [text] NULL,
	[artifacttypeid] [decimal](19, 0) NULL,
	[objecturi] [text] NULL,
	[object] [text] NULL,
	[maturitylevel] [text] NULL,
	[maturitylevel2] [text] NULL,
	[iskeyapplication] [varchar](5) NULL,
	[iskeyreport] [varchar](5) NULL,
	[enterprise] [text] NULL,
	[division] [text] NULL,
	[businessunit] [text] NULL,
	[function] [text] NULL,
	[subfunction] [text] NULL,
	[level5] [text] NULL,
	[level6] [text] NULL,
	[level7] [text] NULL,
	[objectscore] [decimal](38, 10) NULL,
	[effectivedate] [varchar](100) NULL,
	[dss_workid] [text] NULL,
	[dss_id] [decimal](38, 10) NOT NULL,
	[dss_loadtimestamp] [varchar](100) NULL,
	[dss_processtimestamp] [varchar](100) NULL,
 CONSTRAINT [ds_1380_1141_b0db3e_1579871270_PK] PRIMARY KEY CLUSTERED 
(
	[dss_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[InsertNewEnvironment]    Script Date: 8/23/2018 4:03:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*
	Created: 2018-02-19 By Sarath Thottempudi/Jingsong Ou
	Purpose: Create new client environment.
	Note:  1. This SP will not populate DatabaseServer
	       2. After running this SP, Copy the Client Environment database from template. 
		   3. After the client database is up. Update Company Status: UPDATE [dbo].[Company] SET Status = 'Active' WHERE ID = @CompanyID;
	       4. @DatabaseServerName and @DatabaseServerEventTopic must match the record in dbo.DatabaseServer
		   5. @IdpSsoEndpoint and @IdpSloEndpoint get from client
	Return: "EnvironmentID" as recordset.
	Example:

	EXECUTE [dbo].[InsertNewEnvironment]
	        @ClientName = 'TestClient2'
		   ,@DatabaseServerName = 'd3sdev.database.windows.net'
		   ,@DatabaseServerEventTopic = 'events-dev'
		   ,@EnvironmentLevelID = 1
		   ,@CompanyNotes = 'Test company note2'
		   ,@CompanyName = 'Test CompanyName2'
		   ,@IdpDomainCertificateName = 'Infogix Signing Certificate - 2018-21'
		   ,@SpDomainCertificateName = 'Infogix Signing Certificate - 2018-21'
		   ,@IdpSsoEndpoint = 'https://login.microsoftonline.com/42df87fc-485e-4626-b041-0747f9da6761/saml2'
		   ,@IdpSloEndpoint = 'https://login.microsoftonline.com/42df87fc-485e-4626-b041-0747f9da6761/saml2'
		   ,@PrimaryUrlPrefix = 'test.preview'
		   ,@SecondaryUrlPrefix = 'test-igx.preview'

 */
CREATE PROCEDURE [dbo].[InsertNewEnvironment]
  @ClientName NVARCHAR(500)
 ,@IsPoc BIT = 1   
 ,@DatabaseServerName VARCHAR(250) 
 ,@DatabaseServerEventTopic VARCHAR(250) /* events, events-dev, events-nightly and events-uat (For POC usually is events-nightly)*/
 ,@EnvironmentLevelID INT = 1     /* 0='NIGHTLY'; 1='CLIENTDEV'; 2='UAT'; 3='PROD'; 4='LEGACYDEV'; */
 ,@CompanySynchAgentLog BIT = 0
 ,@CompanyNotes NVARCHAR(500) = NULL
 ,@CompanyName VARCHAR(250) = NULL
 ,@NeedSSO  BIT = 0
 ,@IdpDomainCertificateName NVARCHAR(250) = NULL  /* Only required when @NeedSSO = 1 */
 ,@SpDomainCertificateName NVARCHAR(250) = NULL   /* Only required when @NeedSSO = 1 */
 ,@IdpSsoEndpoint VARCHAR(1000)    = NULL         /* Only required when @NeedSSO = 1 */
 ,@IdpSloEndpoint VARCHAR(1000)     = NULL        /* Only required when @NeedSSO = 1 */
 ,@DomainSettingHashAlgorithmType INT = 1         /* Only required when @NeedSSO = 1 */
 ,@DomainSettingSignInitialSSORequest BIT = 0     /* Only required when @NeedSSO = 1 */
 ,@PrimaryUrlPrefix NVARCHAR(50)  -- Example lmtom.preview
 ,@SecondaryUrlPrefix NVARCHAR(50) -- Example lmtom-igx.preview
 ,@PriamryAllowNewUserLogin BIT = 0
 ,@SecondaryAllowNewUserLogin BIT = 1
AS
BEGIN
  DECLARE @ErrorSeverity_Parameter INT = 16
         ,@ErrorState_Parameter INT = 1
		 ,@PrimaryAuthenticationType INT = 1
		 ,@SecondaryAuthenticationType INT = 2
		 ,@ClientStatus BIT
		 ;
  DECLARE @ClientID INT
         ,@EnvironmentID INT
		 ,@DatabaseServerID INT
		 ,@CompanyID INT
		 ,@IdpDomainCertificateID INT
		 ,@SpDomainCertificateID INT
		 ,@PrimayDomainSettingID INT
		 ,@SecondaryDomainSettingID INT
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
		    SET @ClientStatus = 1
			IF(@IsPoc = 1)
			BEGIN
				SET @ClientStatus = 0
			END;
			INSERT INTO [dbo].[Client]([Name], [Status])
			VALUES(@ClientName, @ClientStatus);
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
			INSERT INTO [dbo].[Company] ([Status], DatabaseServerID, SynchAgentLog, ClientID, EnvironmentLevel, Notes, [Name])
			VALUES('Inactive', @DatabaseServerID, @CompanySynchAgentLog, @ClientID, @EnvironmentLevelID, @CompanyNotes, @CompanyName);
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
USE [master]
GO
ALTER DATABASE [D3S_All_Reports] SET  READ_WRITE 
GO
