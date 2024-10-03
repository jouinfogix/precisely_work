

/***************************************************************************************
    Please note that DO NOT USE this script anymore! Table dbo.CompanySetting is removed!
***************************************************************************************/

/*
	Purpose: Deponds on the request, we might need to copy CompanySetting when we copy the environment. 
	Please fill in @SourceCompanyID and @TargetCompanyID before proceed the quries.
*/

DECLARE 
 /* Setting ID. Do not need to be changed everytime */ @SourceSettingId INT = 0,
 /* From CompanyID */ @SourceCompanyID INT = 0,
 /* To CompanyID */   @TargetCompanyID INT = 0;
 


/* SettingID=2 -> CompanyLogo */
SET @SourceSettingId = 2;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=3 -> CompanyIcon */
SET @SourceSettingId = 3;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=9 -> HideData3SixtyUsers */
SET @SourceSettingId = 9;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=13 -> DefaultSearchTypes */
SET @SourceSettingId = 13;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=17 -> DisableIssueManagement */
SET @SourceSettingId = 17;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=20 -> EnableShoppingCart */
SET @SourceSettingId = 20;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=21 -> EnableSagacity */
SET @SourceSettingId = 21;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=23 -> SearchExactMatch */
SET @SourceSettingId = 23;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=34 -> SessionTimeout */
SET @SourceSettingId = 34;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=37 -> ShowFavorites */
SET @SourceSettingId = 37;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=39 -> ShowHomeAssignmentTile */
SET @SourceSettingId = 39;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=40 -> ShowHomeBoardTile */
SET @SourceSettingId = 40;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId  AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId  AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=41 -> ShowHomeActivityTile */
SET @SourceSettingId = 41;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=42 -> ShowHomePageTitle */
SET @SourceSettingId = 42;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=43 -> HomePageTitleSize */
SET @SourceSettingId = 43;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=44 -> HomePageTitleColor */
SET @SourceSettingId = 44;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=45 -> HomePageBackgroundImage */
SET @SourceSettingId = 45;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=57 -> ShowAllUsersAPIKey */
SET @SourceSettingId = 57;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=58 -> WorkflowCatchAllGroup */
SET @SourceSettingId = 58;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=59 -> WorkflowDigestEmailEnabled */
SET @SourceSettingId = 59;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=60 -> MaxDropdownItems */
SET @SourceSettingId = 60;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=61 -> WriteActionDescription */
SET @SourceSettingId = 61;
 IF NOT EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=62 -> UseNewMarkitLineageGeneration */
SET @SourceSettingId = 62;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID  AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=63 -> ShowFusionRules */
SET @SourceSettingId = 63;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=64 -> RequestCertificationDraft */
SET @SourceSettingId = 64;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=65 -> FieldJsonPropertyLoadLimitToTopLevel */
SET @SourceSettingId = 65;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=68 -> LineageVersion */
SET @SourceSettingId = 68;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END

/* SettingID=70 -> FusionEnabled */
SET @SourceSettingId = 70;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END
 
 /* SettingID=73 -> GovernanceRoleReferenceListUid */
 SET @SourceSettingId = 73;
 IF EXISTS(SELECT 1 FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @TargetCompanyID)
 BEGIN
      UPDATE Target SET Target.[Value] = Source.[Value] FROM
             [dbo].[CompanySetting] Target INNER JOIN [dbo].[CompanySetting] Source
             ON Target.[SettingID] = Source.[SettingID]  AND Target.[CompanyID] = @TargetCompanyID AND Source.[CompanyID]  = @SourceCompanyID AND Source.[SettingID]  = @SourceSettingId;
 END
 ELSE
 BEGIN
      INSERT INTO [dbo].[CompanySetting]([CompanyID], [SettingID], [Value])
      SELECT @TargetCompanyID AS [CompanyID], [SettingID], [Value] FROM [dbo].[CompanySetting] WHERE [SettingID] = @SourceSettingId AND [CompanyID] = @SourceCompanyID;
 END