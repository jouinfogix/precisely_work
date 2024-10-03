

IF OBJECT_ID('SetCompanyResource', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[SetCompanyResource];
GO
 /*
	Created: 2018-03-19 By Jingsong Ou
	Purpose: Insert/Update table CompanyResource
	Note:  
	       1.The SP will always ONLY inser/update one record at a time
		   2.The SP will only update column IsAdministrator. It will NOT update CompanyID and REsourceID
	       3.It will return the record that has just inserted
		   4. Get CompanyID from table [dbo].[Company] and
		      ResourID from table [dbo].[Resource]
	      
	Example:

	EXECUTE [dbo].[SetCompanyResource]
	       @CompanyID = 128
          ,@ResourceID = 6412
          ,@IsAdministrator = 0

 */

CREATE PROCEDURE [dbo].[SetCompanyResource]
 @CompanyID INT
,@ResourceID INT
,@IsAdministrator BIT
AS 
BEGIN
DECLARE
     @mCount INT = 0
    ,@ErrorSeverity_Default INT = 16
    ,@ErrorState_Default INT = 1;

    IF(NOT EXISTS(SELECT 1 FROM [dbo].[Company] WHERE ID = @CompanyID))
	BEGIN
		RAISERROR('Parameter @CompanyID does not exists.', @ErrorSeverity_Default, @ErrorSeverity_Default);
	END;
	IF(NOT EXISTS(SELECT 1 FROM [dbo].[Resource] WHERE ID = @ResourceID))
	BEGIN
		RAISERROR('Parameter @ResourceID does not exists.', @ErrorSeverity_Default, @ErrorSeverity_Default);
	END;

	SELECT @mCount = COUNT(1) FROM [dbo].[CompanyResource] WHERE [CompanyID] = @CompanyID AND [ResourceID] = @ResourceID;
	
	IF(@mCount = 0)
	BEGIN
		INSERT INTO [dbo].[CompanyResource](
		     [CompanyID] 
			,[ResourceID] 
			,[IsAdministrator]
			)
		VALUES(
		     @CompanyID
		    ,@ResourceID
			,@IsAdministrator
			);
	END
	ELSE IF(@mCount = 1)
	BEGIN
		UPDATE [dbo].[CompanyResource] 
		SET IsAdministrator = @IsAdministrator 
		WHERE  [CompanyID] = @CompanyID AND 
		       [ResourceID] = @ResourceID;
	END
	ELSE
	BEGIN
		RAISERROR('Error, try to update more than one record in table  [dbo].[CompanyResource]!', @ErrorSeverity_Default, @ErrorSeverity_Default);
	END;

	SELECT CompanyID, ResourceID, IsAdministrator FROM [dbo].[CompanyResource] WHERE [CompanyID] = @CompanyID AND [ResourceID] = @ResourceID;
END;

