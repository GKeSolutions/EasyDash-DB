IF OBJECT_ID('ed.ScheduledNotification', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[ScheduledNotification](
	ID [int] IDENTITY(1,1) NOT NULL,
	IsActive BIT DEFAULT 1,
	NotificationTemplate INT NOT NULL,
	Scheduler INT NOT NULL,
	NotifyAfterDays INT,
	ReassignTo [uniqueidentifier],
	CcContact NVARCHAR(200),
	IsCancelProcess BIT DEFAULT 0,
	PRIMARY KEY (ID),
	FOREIGN KEY (NotificationTemplate) REFERENCES ed.NotificationTemplate(ID),
	FOREIGN KEY (Scheduler) REFERENCES ed.Scheduler(ID)
)
END;