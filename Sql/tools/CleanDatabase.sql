/* Drop all non-system stored procs */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] = 'P' AND SCHEMA_NAME([schema_id])='ed' ORDER BY [name])

WHILE @name is not null
BEGIN
    SELECT @SQL = 'DROP PROCEDURE [ed].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Procedure: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] = 'P' AND [name] > @name AND SCHEMA_NAME([schema_id])='ed' ORDER BY [name])
END
GO

/* Drop all views */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] = 'V' AND SCHEMA_NAME([schema_id])='ed' ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP VIEW [ed].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped View: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] = 'V' AND SCHEMA_NAME([schema_id])='ed' AND [name] > @name ORDER BY [name])
END
GO

/* Drop all functions */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND SCHEMA_NAME([schema_id])='ed' ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP FUNCTION [ed].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Function: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND SCHEMA_NAME([schema_id])='ed' AND [name] > @name ORDER BY [name])
END
GO

/* Drop all Foreign Key constraints */
DECLARE @name VARCHAR(128)
DECLARE @constraint VARCHAR(254)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_SCHEMA = 'ed' ORDER BY TABLE_NAME)

WHILE @name is not null
BEGIN
    SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_SCHEMA = 'ed' AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    WHILE @constraint IS NOT NULL
    BEGIN
        SELECT @SQL = 'ALTER TABLE [ed].[' + RTRIM(@name) +'] DROP CONSTRAINT [' + RTRIM(@constraint) +']'
        EXEC (@SQL)
        PRINT 'Dropped FK Constraint: ' + @constraint + ' on ' + @name
        SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_SCHEMA = 'ed' AND CONSTRAINT_NAME <> @constraint AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    END
SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_SCHEMA = 'ed' ORDER BY TABLE_NAME)
END
GO

/* Drop all Primary Key constraints */
DECLARE @name VARCHAR(128)
DECLARE @constraint VARCHAR(254)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND CONSTRAINT_SCHEMA = 'ed' ORDER BY TABLE_NAME)

WHILE @name IS NOT NULL
BEGIN
    SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND CONSTRAINT_SCHEMA = 'ed' AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    WHILE @constraint is not null
    BEGIN
        SELECT @SQL = 'ALTER TABLE [ed].[' + RTRIM(@name) +'] DROP CONSTRAINT [' + RTRIM(@constraint)+']'
        EXEC (@SQL)
        PRINT 'Dropped PK Constraint: ' + @constraint + ' on ' + @name
        SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND CONSTRAINT_SCHEMA = 'ed' AND CONSTRAINT_NAME <> @constraint AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
    END
SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND CONSTRAINT_SCHEMA = 'ed' ORDER BY TABLE_NAME)
END
GO

/* Drop all tables */
DECLARE @name VARCHAR(128)
DECLARE @SQL VARCHAR(254)

SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] = 'U' AND SCHEMA_NAME([schema_id])='ed' ORDER BY [name])

WHILE @name IS NOT NULL
BEGIN
    SELECT @SQL = 'DROP TABLE [ed].[' + RTRIM(@name) +']'
    EXEC (@SQL)
    PRINT 'Dropped Table: ' + @name
    SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [type] = 'U' AND SCHEMA_NAME([schema_id])='ed' AND [name] > @name ORDER BY [name])
END
GO