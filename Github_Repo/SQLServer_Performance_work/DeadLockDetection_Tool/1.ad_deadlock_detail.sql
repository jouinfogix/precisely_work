USE [DBA]
GO

/****** Object:  Table [dbo].[ad_deadlock_detail]    Script Date: 2/20/2024 5:19:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ad_deadlock_detail](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[timestamp_utc] [datetime2](7) NULL,
	[victimProcessid] [varchar](200) NULL,
	[processid] [varchar](200) NULL,
	[transactionname] [varchar](100) NULL,
	[lasttranstarted] [varchar](100) NULL,
	[lockMode] [varchar](50) NULL,
	[status] [varchar](50) NULL,
	[spid] [int] NULL,
	[clientapp] [varchar](100) NULL,
	[hostname] [varchar](100) NULL,
	[loginname] [varchar](50) NULL,
	[currentdbname] [varchar](50) NULL,
	[lockTimeout] [bigint] NULL,
	[keylock_objectname] [varchar](200) NULL,
	[inputbuf] [varchar](2000) NULL,
 CONSTRAINT [PK_ad_deadlock_detail] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


