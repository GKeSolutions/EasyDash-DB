IF OBJECT_ID('ed.NotificationType', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[NotificationType](
	ID [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](100) NULL,
	PRIMARY KEY (ID)
)

INSERT INTO [ed].[NotificationType] ([Code] ,[Description]) SELECT 'ActionList', 'Action List' WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationType] WHERE Code = 'ActionList');
INSERT INTO [ed].[NotificationType] ([Code] ,[Description]) SELECT 'MissingTime', 'Missing Time' WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationType] WHERE Code = 'MissingTime');

END