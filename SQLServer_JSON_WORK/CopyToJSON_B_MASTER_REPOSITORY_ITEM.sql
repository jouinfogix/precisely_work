
/********************************************************************

 Script for converting ATTR_DATA FROM Xml to JSON (NVARCHAR(MAX)) 

 The simple performance testing on my laptop (SQL 2019 Developer Edition) indicates that JSON parser performance is 30% better than XML parser time.
	Get 1 million records from XML:                logical reads 112212; CPU time = 7313 ms
	Get 1 million records from JSON:               logical reads 112077; CPU time = 5531 ms
	Get 1 million records wihout XML/JSON parsing: logical reads 112212  CPU time = 1797 ms

	Extra CPU time for XML parser:  7313 - 1797 = 5516 ms
	Extra CPU time for JSON parser: 5531 - 1797 = 3734 ms

 I did testing on table [dbo].[B_MASTER_REPOSITORY_ITEM] with XML and [dbo].[B_MASTER_REPOSITORY_ITEM_JSON] with JSON (nvarchar(MAX)) column "ATTR_DATA"

 
  THis article is saying JSON is better except the size, but I've noticed that the sample query in the articale only use small amount of data.
  https://medium.com/hackernoon/xml-vs-json-shootout-which-should-i-use-in-sql-server-7eefa4dc7553

  This artical indicates JSON has much better performance, but it only tested on XML/JSON string variable (data is not from table).
  I tried it too, the performance indeed is much better by using JSON variable.
  https://techcommunity.microsoft.com/t5/sql-server-blog/json-parsing-10x-faster-than-xml-parsing/ba-p/385700


*********************************************************************/

/*   
Use "CREAT_SecondTable_WithJSON.sql" to create second table with JSON column.
*/



-- Sample query
SELECT TOP 1000 A.ITEM_ID, A.REPOSITORY_ID, B.[key], B.[value]
FROM [dbo].[B_MASTER_REPOSITORY_ITEM_JSON] A
OUTER APPLY OPENJSON(ATTR_DATA, '$') B
WHERE B.[value] LIKE '%ok%'
ORDER BY A.ITEM_ID, A.REPOSITORY_ID;

----------------------------------------------------
-- Performance testing: JSON parser is taking 68% of XML parser time
----------------------------------------------------

-- Get value from XML:  logical reads 112212; CPU time = 7313 ms
set statistics io ON;
set statistics time on;
SELECT TOP 1000000 ATTR_DATA.value('(/Item/F_1000000)[1]', 'nvarchar(max)') AS X
FROM [dbo].[B_MASTER_REPOSITORY_ITEM]
set statistics io OFF;
set statistics time OFF;

-- Get value from JSON:  logical reads 112077; CPU time = 5531 ms
set statistics io ON;
set statistics time on;
SELECT TOP 1000000  JSON_VALUE(ATTR_DATA, '$.F_1000000') AS X
FROM [dbo].[B_MASTER_REPOSITORY_ITEM_JSON] 
set statistics io OFF;
set statistics time OFF;


-- Get value wihout XML/JSON parsing: logical reads 112212 CPU time = 1797 ms
set statistics io ON;
set statistics time on;
SELECT TOP 1000000 ATTR_DATA AS X
FROM [dbo].[B_MASTER_REPOSITORY_ITEM]
set statistics io OFF;
set statistics time OFF;





