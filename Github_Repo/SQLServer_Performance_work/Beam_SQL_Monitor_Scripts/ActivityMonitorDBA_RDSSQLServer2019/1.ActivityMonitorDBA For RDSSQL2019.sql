IF EXISTS 
   (
     SELECT name FROM master.dbo.sysdatabases 
    WHERE name = N'DBA'
    )
BEGIN
    SELECT 'Database DBA already Exist' AS Message
END
ELSE
BEGIN
SELECT 'Database DBA Not Exist' AS Message
CREATE DATABASE [DBA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBA', FILENAME = N'D:\rdsdbdata\DATA\DBA.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB)
 LOG ON 
( NAME = N'DBA_log', FILENAME = N'D:\rdsdbdata\DATA\DBA_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )

ALTER DATABASE [DBA] SET COMPATIBILITY_LEVEL = 150
ALTER DATABASE [DBA] SET ANSI_NULL_DEFAULT OFF 
ALTER DATABASE [DBA] SET ANSI_NULLS OFF 
ALTER DATABASE [DBA] SET ANSI_PADDING OFF 
ALTER DATABASE [DBA] SET ANSI_WARNINGS OFF 
ALTER DATABASE [DBA] SET ARITHABORT OFF 
ALTER DATABASE [DBA] SET AUTO_CLOSE OFF 
ALTER DATABASE [DBA] SET AUTO_SHRINK OFF 
ALTER DATABASE [DBA] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
ALTER DATABASE [DBA] SET AUTO_UPDATE_STATISTICS ON 
ALTER DATABASE [DBA] SET CURSOR_CLOSE_ON_COMMIT OFF 
ALTER DATABASE [DBA] SET CURSOR_DEFAULT  GLOBAL 
ALTER DATABASE [DBA] SET CONCAT_NULL_YIELDS_NULL OFF 
ALTER DATABASE [DBA] SET NUMERIC_ROUNDABORT OFF 
ALTER DATABASE [DBA] SET QUOTED_IDENTIFIER OFF 
ALTER DATABASE [DBA] SET RECURSIVE_TRIGGERS OFF 
ALTER DATABASE [DBA] SET  DISABLE_BROKER 
ALTER DATABASE [DBA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
ALTER DATABASE [DBA] SET DATE_CORRELATION_OPTIMIZATION OFF 
ALTER DATABASE [DBA] SET PARAMETERIZATION SIMPLE 
ALTER DATABASE [DBA] SET READ_COMMITTED_SNAPSHOT OFF 
ALTER DATABASE [DBA] SET  READ_WRITE 
ALTER DATABASE [DBA] SET RECOVERY FULL 
ALTER DATABASE [DBA] SET  MULTI_USER 
ALTER DATABASE [DBA] SET PAGE_VERIFY CHECKSUM  
ALTER DATABASE [DBA] SET TARGET_RECOVERY_TIME = 60 SECONDS 
ALTER DATABASE [DBA] SET DELAYED_DURABILITY = DISABLED 

IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [DBA] MODIFY FILEGROUP [PRIMARY] DEFAULT
END