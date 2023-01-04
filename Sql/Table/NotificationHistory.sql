IF OBJECT_ID('ed.NotificationHistory', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[NotificationHistory](
	ID [int] IDENTITY(1,1) NOT NULL,
	[To] NVARCHAR(MAX),
	Cc NVARCHAR(MAX),
	[Subject] NVARCHAR(500),
	Content NVARCHAR(MAX),
	InsertDate DateTime,
	PRIMARY KEY (ID)
)
END;