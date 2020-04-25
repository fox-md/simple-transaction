USE [master]
GO

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'${DatabaseName}')
BEGIN
	CREATE DATABASE [${DatabaseName}]
END
GO