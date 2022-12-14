IF OBJECT_ID('ed.NotificationTemplate', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[NotificationTemplate](
	ID [int] IDENTITY(1,1) NOT NULL,
	IsActive BIT DEFAULT 1,
	[Description] [nvarchar](100) NULL,
	[Type] INT NOT NULL,
	[Priority] INT NOT NULL,
	[Role] [uniqueidentifier],
	Process NVARCHAR(100),
	TemplateSubject NVARCHAR(500),
	TemplateBody NVARCHAR(MAX),
	PRIMARY KEY (ID),
	FOREIGN KEY (Type) REFERENCES ed.NotificationType(ID)
)
END;