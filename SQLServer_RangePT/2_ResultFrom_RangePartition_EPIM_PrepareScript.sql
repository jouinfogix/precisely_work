
/* Create FileGroup and File for data */

ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp1];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file1],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file1.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp1];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp2];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file2],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file2.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp2];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp3];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file3],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file3.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp3];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp4];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file4],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file4.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp4];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp5];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file5],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file5.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp5];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp6];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file6],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file6.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp6];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp7];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file7],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file7.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp7];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp8];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file8],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file8.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp8];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp9];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file9],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file9.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp9];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp10];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file10],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file10.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp10];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp11];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file11],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file11.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp11];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp12];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file12],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file12.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp12];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp13];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file13],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file13.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp13];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp14];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file14],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file14.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp14];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp15];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file15],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file15.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp15];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_fgp16];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_file16],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_file16.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_fgp16];

/* Create FileGroup and File for index */


ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp1];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile1],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile1.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp1];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp2];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile2],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile2.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp2];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp3];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile3],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile3.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp3];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp4];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile4],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile4.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp4];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp5];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile5],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile5.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp5];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp6];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile6],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile6.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp6];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp7];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile7],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile7.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp7];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp8];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile8],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile8.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp8];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp9];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile9],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile9.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp9];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp10];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile10],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile10.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp10];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp11];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile11],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile11.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp11];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp12];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile12],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile12.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED,FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp12];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp13];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile13],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile13.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp13];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp14];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile14],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile14.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp14];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp15];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile15],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile15.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp15];
ALTER DATABASE [EPIM] ADD FILEGROUP [b_mst_repo_itm_idxfgp16];
ALTER DATABASE [EPIM] ADD FILE (NAME = [b_mst_repo_itm_idxfile16],
     FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\EPIM_Data\b_mst_repo_itm_idxfile16.ndf',
     SIZE = 100MB, MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ) TO FILEGROUP [b_mst_repo_itm_idxfgp16];

/* Create Parition Function and Partition Schema */

USE [EPIM]
GO

CREATE PARTITION FUNCTION [mPartitionFunction] (BIGINT) AS RANGE LEFT FOR VALUES (-1,10039,10040,10339,10340,10341,10342,10343,1010039,1010040,1010339,1010340,1010341,1010342,1010343);
GO

CREATE PARTITION SCHEME [mPartitionScheme] AS PARTITION [mPartitionFunction] TO ([b_mst_repo_itm_fgp1],[b_mst_repo_itm_fgp2],[b_mst_repo_itm_fgp3],[b_mst_repo_itm_fgp4],[b_mst_repo_itm_fgp5],[b_mst_repo_itm_fgp6],[b_mst_repo_itm_fgp7],[b_mst_repo_itm_fgp8],[b_mst_repo_itm_fgp9],[b_mst_repo_itm_fgp10],[b_mst_repo_itm_fgp11],[b_mst_repo_itm_fgp12],[b_mst_repo_itm_fgp13],[b_mst_repo_itm_fgp14],[b_mst_repo_itm_fgp15],[b_mst_repo_itm_fgp16]);
GO

CREATE PARTITION SCHEME [mIndexPartitionScheme] AS PARTITION [mPartitionFunction] TO ([b_mst_repo_itm_idxfgp1],[b_mst_repo_itm_idxfgp2],[b_mst_repo_itm_idxfgp3],[b_mst_repo_itm_idxfgp4],[b_mst_repo_itm_idxfgp5],[b_mst_repo_itm_idxfgp6],[b_mst_repo_itm_idxfgp7],[b_mst_repo_itm_idxfgp8],[b_mst_repo_itm_idxfgp9],[b_mst_repo_itm_idxfgp10],[b_mst_repo_itm_idxfgp11],[b_mst_repo_itm_idxfgp12],[b_mst_repo_itm_idxfgp13],[b_mst_repo_itm_idxfgp14],[b_mst_repo_itm_idxfgp15],[b_mst_repo_itm_idxfgp16]);
GO

/* Re-create Primary Key as Non-Clustered and create a clustered index based on [REPOSITORY_ID] */



DROP INDEX [B_MASTER_REP_ITEM_IE1] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO 
DROP INDEX [B_MASTER_REP_ITEM_IE2] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO 
DROP INDEX [B_MASTER_REP_ITEM_IE3] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO 
DROP INDEX [B_MASTER_REP_ITEM_IE4] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO 
DROP INDEX [B_MASTER_REP_ITEM_IE5] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO 
DROP INDEX [B_MASTER_REP_ITEM_IE7] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO 
DROP INDEX [B_MASTER_REPOSITORY_ITEM_IE6] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO


DROP VIEW [dbo].[Validation_Levels];
GO
UPDATE [dbo].[B_MASTER_REPOSITORY_ITEM] SET [REPOSITORY_ID] = -1 WHERE [REPOSITORY_ID] IS NULL;
ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ALTER COLUMN [REPOSITORY_ID] bigint NOT NULL;

ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] DROP CONSTRAINT [pk__b_master_repo_item];
GO

ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM] ADD  CONSTRAINT [pk__b_master_repo_item] PRIMARY KEY CLUSTERED ([ITEM_ID],[REPOSITORY_ID]) ON [mPartitionScheme]([REPOSITORY_ID]);
GO

/* Re-create Dependancy View */



CREATE VIEW [dbo].[Validation_Levels] WITH SCHEMABINDING
AS
    SELECT	mri.ITEM_ID AS [InternalRecordId], 
			mr.NAME AS [Repository], 
			mri.VALIDATION_LEVEL_IND AS [Validation_Level] 
	FROM [dbo].[B_MASTER_REPOSITORY_ITEM] mri
	INNER JOIN [dbo].[B_MASTER_REPOSITORY] mr ON mr.MASTER_REPOSITORY_ID = mri.REPOSITORY_ID
	INNER JOIN [dbo].[B_REPOSITORY_GROUP] rg ON rg.REPOSITORY_GROUP_ID = mr.REPOSITORY_GROUP_ID
	WHERE rg.NAME NOT IN ('DAM','Automated Sort','Publication Merge','Scheduled Activities','Change Notification')
	AND ISNULL(mri.VALIDATION_LEVEL_IND,0) <> 0

GO

/* Re-Create non-clustered Indexes */

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_IE1')
 DROP INDEX [B_MASTER_REP_ITEM_IE1] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_IE1] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, ITEM_ID ASC, HAS_ERROR_IND ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_IE2')
 DROP INDEX [B_MASTER_REP_ITEM_IE2] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_IE2] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, PLT_ITEM_ID ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_IE3')
 DROP INDEX [B_MASTER_REP_ITEM_IE3] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_IE3] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, PK_COL_1 ASC, PK_COL_2 ASC, PK_COL_3 ASC, PK_COL_4 ASC, PK_COL_5 ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_IE4')
 DROP INDEX [B_MASTER_REP_ITEM_IE4] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_IE4] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, RECORD_STATE ASC, PRODUCTION_STATE ASC, WORKFLOW_STATE ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_IE5')
 DROP INDEX [B_MASTER_REP_ITEM_IE5] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_IE5] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, ATTR_LAST_UPDATE_DATETIME ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_IE7')
 DROP INDEX [B_MASTER_REP_ITEM_IE7] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_IE7] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, ITEM_ID ASC, HAS_ERROR_IND ASC, RECORD_STATE ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REP_ITEM_STAGING_ITEM_ID')
 DROP INDEX [B_MASTER_REP_ITEM_STAGING_ITEM_ID] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REP_ITEM_STAGING_ITEM_ID] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( STAGING_ITEM_ID ASC ) INCLUDE ( [REPOSITORY_ID] )  WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('B_MASTER_REPOSITORY_ITEM') AND [name] = 'B_MASTER_REPOSITORY_ITEM_IE6')
 DROP INDEX [B_MASTER_REPOSITORY_ITEM_IE6] ON [dbo].[B_MASTER_REPOSITORY_ITEM];
GO
 CREATE NONCLUSTERED INDEX [B_MASTER_REPOSITORY_ITEM_IE6] ON [dbo].[B_MASTER_REPOSITORY_ITEM] ( REPOSITORY_ID ASC, STAGING_ITEM_ID ASC ) WITH (PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DROP_EXISTING = OFF ) ON [mIndexPartitionScheme]([REPOSITORY_ID]);
GO


