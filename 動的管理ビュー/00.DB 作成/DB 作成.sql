USE master;
GO

-- Create Database
IF DB_ID('PerfDump') IS NULL
BEGIN
    CREATE DATABASE PerfDump;
    ALTER DATABASE [PerfDump] SET RECOVERY SIMPLE;
    ALTER DATABASE [PerfDump] MODIFY FILE ( NAME = N'PerfDump', SIZE = 100MB );
    ALTER DATABASE [PerfDump] MODIFY FILE ( NAME = N'PerfDump_log', SIZE = 100MB );
    ALTER DATABASE [PerfDump] MODIFY FILE ( NAME = N'PerfDump', FILEGROWTH = 100MB );
    ALTER DATABASE [PerfDump] MODIFY FILE ( NAME = N'PerfDump_log', FILEGROWTH = 100MB );
END
GO
