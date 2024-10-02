
/*   

-- Create table with nvarchar(max) on ATTR_DATA
-- Drop table If Exists [dbo].[B_MASTER_REPOSITORY_ITEM_JSON];

*/

CREATE TABLE [dbo].[B_MASTER_REPOSITORY_ITEM_JSON](
	[ITEM_ID] [bigint] IDENTITY(10000,1) NOT NULL,
	[REPOSITORY_ID] [bigint] NULL,
	[HAS_ERROR_IND] [bigint] NULL,
	[SYNC_ACTION] [bigint] NULL,
	[SYNC_ACTION_DELETE] [bigint] NULL,
	[IS_DUPLICATE] [bigint] NULL,
	[RECORD_STATE] [bigint] NULL,
	[PRODUCTION_STATE] [bigint] NULL,
	[WORKFLOW_STATE] [bigint] NULL,
	[MESSAGE_ID] [nvarchar](200) NULL,
	[TRANSACTION_ID] [nvarchar](200) NULL,
	[ATTR_DATA] [nvarchar](max) NULL ,
	[STATE_UPDATE_TIME] [datetime] NULL,
	[STATE_UPDATE_MSG] [nvarchar](512) NULL,
	[RECLOCK] [bigint] NULL,
	[PK_COL_1] [nvarchar](128) NULL,
	[PK_COL_2] [nvarchar](128) NULL,
	[PK_COL_3] [nvarchar](120) NULL,
	[PK_COL_4] [nvarchar](32) NULL,
	[PK_COL_5] [nvarchar](32) NULL,
	[CREATION_DATETIME] [datetime] NULL,
	[CREATED_BY] [bigint] NULL,
	[LAST_UPDATE_DATETIME] [datetime] NULL,
	[LAST_UPDATE_BY] [bigint] NULL,
	[REPOSITORY_TYPE] [bigint] NULL,
	[MODIFY_ACTION] [nvarchar](32) NULL,
	[ATTR_LAST_UPDATE_DATETIME] [datetime] NULL,
	[ATTR_LAST_UPDATE_BY] [bigint] NULL,
	[EXTERNAL_SESSION_INFO] [nvarchar](512) NULL,
	[PLT_ITEM_ID] [bigint] NULL,
	[STAGING_ITEM_ID] [bigint] NULL,
	[GLOBAL_IND] [bigint] NULL,
	[VALIDATION_LEVEL_IND] [bigint] NULL,
	[OVERALL_ERROR_IND] [bigint] NULL,
	[HAS_ERROR_IND_1] [bigint] NULL,
	[HAS_ERROR_IND_2] [bigint] NULL,
	[HAS_ERROR_IND_3] [bigint] NULL,
	[HAS_ERROR_IND_4] [bigint] NULL,
	[HAS_ERROR_IND_5] [bigint] NULL,
	[SECURITY_CONTEXT_VALUE] [bigint] NULL,
	[MERGED_INTO_ITEM_ID] [bigint] NULL,
 CONSTRAINT [pk__b_master_repo_item_json] PRIMARY KEY CLUSTERED 
(
	[ITEM_ID] ASC
)
)
GO

ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM_JSON] ADD  DEFAULT ((2)) FOR [HAS_ERROR_IND]
GO



/* Generate JSON column "ATTR_DATA" in new table [B_MASTER_REPOSITORY_ITEM_JSON] */

SET IDENTITY_INSERT [dbo].[B_MASTER_REPOSITORY_ITEM_JSON] ON;

INSERT INTO [dbo].[B_MASTER_REPOSITORY_ITEM_JSON]
(
[ITEM_ID],
	[REPOSITORY_ID],
	[HAS_ERROR_IND],
	[SYNC_ACTION],
	[SYNC_ACTION_DELETE],
	[IS_DUPLICATE],
	[RECORD_STATE],
	[PRODUCTION_STATE],
	[WORKFLOW_STATE],
	[MESSAGE_ID],
	[TRANSACTION_ID],
[ATTR_DATA],

    [STATE_UPDATE_TIME],
	[STATE_UPDATE_MSG],
	[RECLOCK],
	[PK_COL_1] ,
	[PK_COL_2],
	[PK_COL_3],
	[PK_COL_4] ,
	[PK_COL_5],
	[CREATION_DATETIME],
	[CREATED_BY] ,
	[LAST_UPDATE_DATETIME],
	[LAST_UPDATE_BY],
	[REPOSITORY_TYPE],
	[MODIFY_ACTION],
	[ATTR_LAST_UPDATE_DATETIME],
	[ATTR_LAST_UPDATE_BY],
	[EXTERNAL_SESSION_INFO],
	[PLT_ITEM_ID],
	[STAGING_ITEM_ID],
	[GLOBAL_IND],
	[VALIDATION_LEVEL_IND],
	[OVERALL_ERROR_IND],
	[HAS_ERROR_IND_1],
	[HAS_ERROR_IND_2],
	[HAS_ERROR_IND_3],
	[HAS_ERROR_IND_4],
	[HAS_ERROR_IND_5] ,
	[SECURITY_CONTEXT_VALUE],
	[MERGED_INTO_ITEM_ID]
)
SELECT 
[ITEM_ID],
	[REPOSITORY_ID],
	[HAS_ERROR_IND],
	[SYNC_ACTION],
	[SYNC_ACTION_DELETE],
	[IS_DUPLICATE],
	[RECORD_STATE],
	[PRODUCTION_STATE],
	[WORKFLOW_STATE],
	[MESSAGE_ID],
	[TRANSACTION_ID],
JSON_MODIFY(JSON_MODIFY(  /* Add ITEM_ID and REPOSITORY_ID to JSON */
(
SELECT Stuff(
  (SELECT TheLine from --this is to glue each row into a string
    (SELECT ',
    {'+ --this is the start of the row, representing the row object in the JSON list
      --the local-name(.) is an eXPath function that gives you the name of the node
      Stuff((SELECT ',"'+coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'),'')+'":"'+
                    REPLACE(STRING_ESCAPE(b.c.value('text()[1]','NVARCHAR(MAX)'), 'JSON'), '\/', '/') +'"' 
             -- 'text()[1]' gives you the text contained in the node      
             from x.a.nodes('*') b(c) --get the row XML and split it into each node
             for xml path(''),TYPE).value('(./text())[1]','NVARCHAR(MAX)')
        ,1,1,'')+'}'--remove the first comma 
   from [ATTR_DATA].nodes('/Item') x(a) --get every row
   ) JSON(theLine) --each row 
  for xml path(''),TYPE).value('.','NVARCHAR(MAX)' )
, 1, 7, '') --remove the first leading comma and space following
)
, '$.ITEM_ID', ITEM_ID), '$.REPOSITORY_ID', REPOSITORY_ID)
AS [ATTR_DATA],

[STATE_UPDATE_TIME],
	[STATE_UPDATE_MSG],
	[RECLOCK],
	[PK_COL_1] ,
	[PK_COL_2],
	[PK_COL_3],
	[PK_COL_4] ,
	[PK_COL_5],
	[CREATION_DATETIME],
	[CREATED_BY] ,
	[LAST_UPDATE_DATETIME],
	[LAST_UPDATE_BY],
	[REPOSITORY_TYPE],
	[MODIFY_ACTION],
	[ATTR_LAST_UPDATE_DATETIME],
	[ATTR_LAST_UPDATE_BY],
	[EXTERNAL_SESSION_INFO],
	[PLT_ITEM_ID],
	[STAGING_ITEM_ID],
	[GLOBAL_IND],
	[VALIDATION_LEVEL_IND],
	[OVERALL_ERROR_IND],
	[HAS_ERROR_IND_1],
	[HAS_ERROR_IND_2],
	[HAS_ERROR_IND_3],
	[HAS_ERROR_IND_4],
	[HAS_ERROR_IND_5] ,
	[SECURITY_CONTEXT_VALUE],  
	[MERGED_INTO_ITEM_ID]
FROM [dbo].[B_MASTER_REPOSITORY_ITEM];

SET IDENTITY_INSERT [dbo].[B_MASTER_REPOSITORY_ITEM_JSON] OFF;

/* Add constraint to make sure it meets JSON format */
ALTER TABLE [dbo].[B_MASTER_REPOSITORY_ITEM_JSON]
ADD CONSTRAINT [B_MASTER_REPOSITORY_ITEM_JSON_Format]
CHECK(ISJSON([ATTR_DATA])>0);