IF OBJECT_ID('ed.NotificationScheduler', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[NotificationScheduler](
	ID [int] IDENTITY(1,1) NOT NULL,
	IsActive BIT DEFAULT 1,
	NotificationTemplate INT NOT NULL,
	Schedule NVARCHAR(500),
	NotifyAfterDays INT,
	ReassignTo [uniqueidentifier],
	CcContact [uniqueidentifier],
	PRIMARY KEY (ID),
	FOREIGN KEY (NotificationTemplate) REFERENCES ed.NotificationTemplate(ID)
)
END;