
-- DBCC FREEPROCCACHE;
DECLARE @database_id INT;
--SELECT @database_id = database_id FROM sys.databases where name = DB_NAME();
DBCC FLUSHPROCINDB(8);
DBCC FREEPROCCACHE;

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT Repository_ID, count(*) AS cnt FROM dbo.[B_MASTER_REPOSITORY_ITEM]
where Repository_ID = 10340 --PartitionKey = [dbo].[mHashPartition](ITEM_ID)
GROUP BY Repository_ID ORDER BY 2 DESC

/*** SELECT aggregate on REPOSITORY_ID ***/

-- Group by all REPOSITORY_ID:
-- Non Partition table logical reads: 210430 (CPU time = 12016 ms,  elapsed time = 3327 ms.)  
-- (Hash partition)Partion table Logical reads: 214788 (CPU time = 10140 ms,  elapsed time = 10368 ms) 
-- (Range partition)Partion table Logical reads: 208926 (CPU time = 8905 ms,  elapsed time = 6491 ms) 
-- (20FG Hash partition)Partion table Logical reads: 214788 (CPU time = 8906 ms,  elapsed time = 9786 ms) 
-- (Shrink File 20FG Hash partition)Partion table Logical reads: 214789 (CPU time = 10859 ms,  elapsed time = 13919 ms) 
-- (Change to io3 20FG Hash partition)Partion table Logical reads: 214789 (CPU time = 9672 ms,  elapsed time = 9682 ms) 

-- Group by one REPOSITORY_ID
-- Non Partition table logical reads: 64050 (CPU time = 4048 ms,  elapsed time = 1116 ms)
-- (Hash partition)Partion table Logical reads: 64677 (CPU time = 2110 ms,  elapsed time = 2103 ms)
-- (Range partition)Partion table Logical reads: 63979 (CPU time = 4250 ms,  elapsed time = 1212 ms)
-- (20FG Hash partition)Partion table Logical reads: 64703 (CPU time = 2531 ms,  elapsed time = 2603 ms) 
-- (Shrink File 20FG Hash partition)Partion table Logical reads: 64703 (CPU time = 2359 ms,  elapsed time = 3081 ms) 
-- (Change to io3 20FG Hash partition)Partion table Logical reads: 64703 (CPU time = 2062 ms,  elapsed time = 2044 ms) 

/*** update by one REPOSITORY_ID: ***/

-- Non Partition table logical reads: 10677103 CPU time = 128422 ms,  elapsed time = 1736020 ms) 
-- (Hash partition) Partion table Logical reads: 1762966 (CPU time = 59469 ms,  elapsed time = 745428 ms)  
-- (Range partition) Partion table Logical reads: 3787490(CPU time = 91546 ms,  elapsed time = 1037097 ms) 
-- (20FG Hash partition)Partion table Logical reads: 3541791 (CPU time = 143906 ms,  elapsed time = 211330 ms) 
-- (Shink File 20FG Hash partition)Partion table Logical reads: 1404630 CPU time = 71875 ms,  elapsed time = 812145 ms 
-- (Change to io3 20FG Hash partition)Partion table Logical reads: 1404630 (CPU time = 55359 ms,  elapsed time = 882668 ms) 

DBCC FLUSHPROCINDB(8);
DBCC FREEPROCCACHE;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
UPDATE dbo.[B_MASTER_REPOSITORY_ITEM]
SET ATTR_DATA = '<Item>
  <F_1016503>1</F_1016503>
  <F_1016506>117726</F_1016506>
  <F_1016505>1</F_1016505>
  <F_1016504>AGM:dataCarrier/A:dataCarrierFamilyTypeCode</F_1016504>
  <F_1016509>EAN_UPC</F_1016509>
  <F_1016508>TM</F_1016508><F888>qvqv</F888>
</Item>'
, MODIFY_ACTION = REPLACE(MODIFY_ACTION, ' TestTest', '')
WHERE Repository_ID = 10343 --AND PartitionKey = [dbo].[mHashPartition](ITEM_ID);  -- 10340 10343


SELECT TOP 1000
    	$PARTITION.mHashPartitionFunction ([PartitionKey]) AS PartitionNumber,
		[PartitionKey],*
FROM [dbo].[B_MASTER_REPOSITORY_ITEM]
WHERE [REPOSITORY_ID] = 10340 AND ITEM_ID % 10 = 9; /* IS NULL */

SET NOCOUNT OFF



