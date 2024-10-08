USE [DataUsage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigurationData](
	[ServerID] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[TopRecordSelectCount] [int] NULL,
	[NumOfDaysHistoryToKeep] [int] NULL,
 CONSTRAINT [PK_ConfigurationData] PRIMARY KEY CLUSTERED 
(
	[ServerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IntermediateTableSize](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerID] [int] NOT NULL,
	[SchemaName] [varchar](128) NOT NULL,
	[TableName] [varchar](255) NULL,
	[RowCount] [bigint] NULL,
	[TotalSpaceMB] [decimal](20, 2) NULL,
	[UsedSpaceMB] [decimal](20, 2) NULL,
	[UnusedSpaceMB] [decimal](20, 2) NULL,
 CONSTRAINT [PK_IntermediateTableSize] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerList](
	[ID] [int] NOT NULL,
	[ServerName] [varchar](100) NOT NULL,
	[TotalSpaceGB] [int] NOT NULL,
	[FreeSpaceGB] [int] NOT NULL,
	[PctFree] [varchar](10) NOT NULL,
 CONSTRAINT [PK_ServerList] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServerSizeHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerID] [int] NOT NULL,
	[RowCount] [bigint] NOT NULL,
	[TotalSpaceGB] [int] NOT NULL,
	[FreeSpaceGB] [int] NOT NULL,
	[PctFree] [varchar](10) NOT NULL,
	[DisplayDate] [date] NULL,
 CONSTRAINT [PK_ServerSizeHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData],
 CONSTRAINT [UQ_ServerSizeHistory_ServerID_Date] UNIQUE NONCLUSTERED 
(
	[ServerID] ASC,
	[DisplayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableSizeChangeHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerID] [int] NOT NULL,
	[SchemaName] [varchar](128) NOT NULL,
	[TableName] [varchar](255) NOT NULL,
	[RowCountChange] [bigint] NOT NULL,
	[DisplayDate] [date] NOT NULL,
	[HasRetention] [bit] NULL,
 CONSTRAINT [PK_TableSizeChangeHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData],
 CONSTRAINT [UQ_TableSizeChangeHistory_ServerID_Date] UNIQUE NONCLUSTERED 
(
	[ServerID] ASC,
	[SchemaName] ASC,
	[TableName] ASC,
	[DisplayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableSizeHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerID] [int] NOT NULL,
	[SchemaName] [varchar](128) NOT NULL,
	[TableName] [varchar](255) NOT NULL,
	[RowCount] [bigint] NOT NULL,
	[TotalSpaceMB] [decimal](20, 2) NOT NULL,
	[UsedSpaceMB] [decimal](20, 2) NOT NULL,
	[UnusedSpaceMB] [decimal](20, 2) NOT NULL,
	[DisplayDate] [date] NOT NULL,
 CONSTRAINT [PK_TableSizeHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData],
 CONSTRAINT [UQ_TableSizeHistory_ServerID_Date] UNIQUE NONCLUSTERED 
(
	[ServerID] ASC,
	[SchemaName] ASC,
	[TableName] ASC,
	[DisplayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopTableInfoHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerID] [int] NOT NULL,
	[Min_UpdateTime] [datetime] NOT NULL,
	[SchemaName] [varchar](128) NOT NULL,
	[TableName] [varchar](255) NOT NULL,
	[DisplayDate] [date] NOT NULL,
 CONSTRAINT [PK_TopTableInfoHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData],
 CONSTRAINT [UQ_TopTableInfoHistory_ServerID_Date] UNIQUE NONCLUSTERED 
(
	[ServerID] ASC,
	[SchemaName] ASC,
	[TableName] ASC,
	[DisplayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [UserData]
) ON [UserData]
GO
ALTER TABLE [dbo].[TopTableInfoHistory] ADD  CONSTRAINT [df_TopTableInfoHistory_DisplayDate]  DEFAULT (CONVERT([date],getdate())) FOR [DisplayDate]
GO
ALTER TABLE [dbo].[IntermediateTableSize]  WITH NOCHECK ADD  CONSTRAINT [FK_IntermediateTableSize_ServerList] FOREIGN KEY([ServerID])
REFERENCES [dbo].[ServerList] ([ID])
GO
ALTER TABLE [dbo].[IntermediateTableSize] CHECK CONSTRAINT [FK_IntermediateTableSize_ServerList]
GO
ALTER TABLE [dbo].[ServerSizeHistory]  WITH CHECK ADD  CONSTRAINT [FK_ServerSizeHistory_ServerList] FOREIGN KEY([ServerID])
REFERENCES [dbo].[ServerList] ([ID])
GO
ALTER TABLE [dbo].[ServerSizeHistory] CHECK CONSTRAINT [FK_ServerSizeHistory_ServerList]
GO
ALTER TABLE [dbo].[TableSizeChangeHistory]  WITH CHECK ADD  CONSTRAINT [FK_TableSizeChangeHistory_ServerList] FOREIGN KEY([ServerID])
REFERENCES [dbo].[ServerList] ([ID])
GO
ALTER TABLE [dbo].[TableSizeChangeHistory] CHECK CONSTRAINT [FK_TableSizeChangeHistory_ServerList]
GO
ALTER TABLE [dbo].[TableSizeHistory]  WITH CHECK ADD  CONSTRAINT [FK_TableSizeHistory_ServerList] FOREIGN KEY([ServerID])
REFERENCES [dbo].[ServerList] ([ID])
GO
ALTER TABLE [dbo].[TableSizeHistory] CHECK CONSTRAINT [FK_TableSizeHistory_ServerList]
GO
ALTER TABLE [dbo].[TopTableInfoHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_TopTableInfo_ServerList] FOREIGN KEY([ServerID])
REFERENCES [dbo].[ServerList] ([ID])
GO
ALTER TABLE [dbo].[TopTableInfoHistory] CHECK CONSTRAINT [FK_TopTableInfo_ServerList]
GO
