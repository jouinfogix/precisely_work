
ALTER DATABASE [DataUsage] ADD FILEGROUP [UserData_Index];
ALTER DATABASE [DataUsage] ADD FILE (NAME = [UserData_Index1],
     FILENAME = 'D:\rdsdbdata\DATA\UserData_Index1.ndf',
     SIZE = 10MB, MAXSIZE = 200GB, FILEGROWTH = 10MB ) TO FILEGROUP [UserData_Index];

ALTER TABLE [dbo].[TableSizeChangeHistory]
ADD [LastRetentionDate] DATE;

ALTER TABLE [dbo].[TableSizeChangeHistory] DROP CONSTRAINT [UQ_TableSizeChangeHistory_ServerID_Date];

ALTER TABLE [dbo].[TableSizeChangeHistory] ADD CONSTRAINT [UQ_TableSizeChangeHistory_ServerID_Date] UNIQUE NONCLUSTERED 
(
	[ServerID] ASC,
	[SchemaName] ASC,
	[TableName] ASC,
	[DisplayDate] ASC
) ON [UserData_Index];
GO

DROP PROCEDURE [dbo].[sp_ProcessTopTableInfo];
DROP TABLE  [dbo].[TopTableInfoHistory];