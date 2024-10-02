/****** Script for SelectTopNRows command from SSMS  ******/

USE DBA;
GO

/*** Fill in the @Start_Collection_Time and @End_Collection_Time to start ***/
/*** If "blockby_blocking_session_id" IS NOT NULL, then there is a chain blocking ***/
DECLARE @Start_Collection_Time DATETIME = '2024-08-06 14:00:00.000',
        @End_Collection_Time DATETIME = '2030-08-08';

-- Set end time as 3 hours after start_time if needed
-- SET @End_Collection_Time = DATEADD(hour, 3, @End_Collection_Time);



SELECT [Current].[dd hh:mm:ss.mss] AS duration,[BlockBy].[dd hh:mm:ss.mss] AS blokby_session_duration, 
[Current].[session_id] AS session_id, [BlockBy].[session_id] as blokby_session_id, 
[BlockBy].[blocking_session_id] AS blockby_blocking_session_id,
[Current].[program_name] AS program, [BlockBy].[program_name] AS blokby_program, 
[Current].[sql_text] as sql_text, [BlockBy].[sql_text] as blokby_sql_text, 
[Current].[start_time] AS session_start_time, [BlockBy].[start_time] AS blokby_session_start_time,
[Current].[collection_time]
FROM [dbo].[Tbl_Activity_History_Monitor] [BlockBy]
 LEFT JOIN [dbo].[Tbl_Activity_History_Monitor] [Current] 
 ON [Current].[blocking_session_ID] = [BlockBy].[session_id]
WHERE EXISTS(
  SELECT 1 FROM [dbo].[Tbl_Activity_History_Monitor] [H]
  WHERE [H].[collection_time] BETWEEN @Start_Collection_Time AND @End_Collection_Time
  AND [H].blocking_session_ID IS NOT NULL AND [H].[blocking_session_ID] = [BlockBy].[session_id] )
  AND [BlockBy].[collection_time] BETWEEN @Start_Collection_Time AND @End_Collection_Time
  AND [Current].[collection_time] BETWEEN @Start_Collection_Time AND @End_Collection_Time
ORDER BY  [Current].[collection_time] DESC;