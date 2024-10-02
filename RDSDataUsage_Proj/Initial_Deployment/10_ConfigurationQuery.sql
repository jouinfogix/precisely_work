
USE DataUsage
GO

INSERT INTO [dbo].[ConfigurationData](ServerID, ServerName, TopRecordSelectCount, [NumOfDaysHistoryToKeep])
VALUES(3, 'massmutualdevelopment', 50, 365);

INSERT INTO [dbo].[ConfigurationData](ServerID, ServerName, TopRecordSelectCount, [NumOfDaysHistoryToKeep])
VALUES(2, 'mmtstclstrdb', 50, 365);

INSERT INTO [dbo].[ConfigurationData](ServerID, ServerName, TopRecordSelectCount, [NumOfDaysHistoryToKeep])
VALUES(1, 'massmutualprod', 50, 365);

USE [master]
GO

-- Dev : kjB=A*HNK6Zb5tgC
-- Test: T}J8z2Pg])-9L$p(
-- Prod: KC%S?u_9:hAe5J2q

CREATE LOGIN [DBOperator] WITH PASSWORD=N'KC%S?u_9:hAe5J2q', 
DEFAULT_DATABASE=[DataUsage], DEFAULT_LANGUAGE=[us_english], 
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE DataUsage
GO
CREATE USER [DBOperator] FOR LOGIN [DBOperator] WITH DEFAULT_SCHEMA=[dbo]
GO
EXEC sp_addrolemember 'db_datareader', 'DBOperator'
GRANT INSERT ON [dbo].[TopTableInfoHistory] TO DBOperator;
GRANT EXECUTE ON SCHEMA::dbo TO DBOperator;
GO

USE MASTER
GO
GRANT VIEW SERVER STATE TO DBOperator;
GRANT VIEW ANY DEFINITION to DBOperator;

USE IAIGXDB
GO
CREATE USER [DBOperator] FOR LOGIN [DBOperator] WITH DEFAULT_SCHEMA=[dbo]
GO
EXEC sp_addrolemember 'db_datareader', 'DBOperator'
GRANT SELECT ON SCHEMA::dbo TO DBOperator;
GO
GRANT SELECT ON SCHEMA::sys TO DBOperator;
GO


/*

USE IAIGXDB
GO

CREATE TABLE UP_MM (ID int, mname varchar(100), UPDATETIME datetime);
INSERT INTO UP_MM VALUES(1, 'mmm1', '1990-01-01'),(2, 'mmm1', '1990-01-02'),(3, 'mmm3', '1990-01-03');

CREATE TABLE UP_MM2 (ID int, mname varchar(100), UPDATETIME datetime);
INSERT INTO UP_MM2 VALUES(11, 'mmm2', '1992-01-01'),(12, 'mmm2', '1992-01-02'),(13, 'mmm3', '1992-01-03');


*/