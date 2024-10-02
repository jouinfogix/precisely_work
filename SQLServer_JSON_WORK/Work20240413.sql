--DECLARE @xml XML = '<?xml version="1.0"?>
--    <catalog>
--       <book id="bk101">
--          <author>Gambardella, Matthew</author>
--       </book>
--       <book id="bk102">
--          <author>Ralls, Kim</author>
--       </book>
--    </catalog>''';
--SELECT b.value('@id', 'nvarchar(MAX)') AS book
--    ,b.value('author[1]', 'nvarchar(MAX)') AS author
--    -- the rest of your columns
--FROM @xml.nodes('/catalog/book') AS a(b)
--FOR JSON AUTO

--Select TOP 1 ATTR_DATA FROM [dbo].[B_MASTER_REPOSITORY_ITEM];

Declare @mXML XML
Select TOP 1 @mXML = ATTR_DATA FROM [dbo].[B_MASTER_REPOSITORY_ITEM];
SELECT Stuff(
  (SELECT TheLine from --this is to glue each row into a string
    (SELECT ',
    {'+ --this is the start of the row, representing the row object in the JSON list
      --the local-name(.) is an eXPath function that gives you the name of the node
      Stuff((SELECT ',"'+coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'),'')+'":"'+
                    b.c.value('text()[1]','NVARCHAR(MAX)') +'"' 
             -- 'text()[1]' gives you the text contained in the node      
             from x.a.nodes('*') b(c) --get the row XML and split it into each node
             for xml path(''),TYPE).value('(./text())[1]','NVARCHAR(MAX)')
        ,1,1,'')+'}'--remove the first comma 
   from @mXML.nodes('/Item') x(a) --get every row
   ) JSON(theLine) --each row 
  for xml path(''),TYPE).value('.','NVARCHAR(MAX)' )
, 1, 7, '') --remove the first leading comma and space following

Select TOP 10  
(
SELECT Stuff(
  (SELECT TheLine from --this is to glue each row into a string
    (SELECT ',
    {'+ --this is the start of the row, representing the row object in the JSON list
      --the local-name(.) is an eXPath function that gives you the name of the node
      Stuff((SELECT ',"'+coalesce(b.c.value('local-name(.)', 'NVARCHAR(255)'),'')+'":"'+
                    b.c.value('text()[1]','NVARCHAR(MAX)') +'"' 
             -- 'text()[1]' gives you the text contained in the node      
             from x.a.nodes('*') b(c) --get the row XML and split it into each node
             for xml path(''),TYPE).value('(./text())[1]','NVARCHAR(MAX)')
        ,1,1,'')+'}'--remove the first comma 
   from ATTR_DATA.nodes('/Item') x(a) --get every row
   ) JSON(theLine) --each row 
  for xml path(''),TYPE).value('.','NVARCHAR(MAX)' )
, 1, 7, '') --remove the first leading comma and space following
) AS ATTR_DATA
FROM [dbo].[B_MASTER_REPOSITORY_ITEM];





,      {"F_1000002":"1","F_1000003":"/app/data/dam-drop","F_1000000":"BulkUploadService","F_1000001":"SourceFolder"}
      {"F_1000002":"1","F_1000003":"/app/data/dam-drop","F_1000000":"BulkUploadService","F_1000001":"SourceFolder"}
      {"F_1000002":"1","F_1000003":"/app/data/dam-drop","F_1000000":"BulkUploadService","F_1000001":"SourceFolder"}

SELECT ASCII('      {"F_1000002":"1","F_1000003":"/app/data/dam-drop","F_1000000":"BulkUploadService","F_1000001":"SourceFolder"}')