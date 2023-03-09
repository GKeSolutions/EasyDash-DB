IF OBJECT_ID('ed.NotificationHistory', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[NotificationHistory](
	ID [int] IDENTITY(1,1) NOT NULL,
	[To] NVARCHAR(MAX),
	Cc NVARCHAR(MAX),
	[Subject] NVARCHAR(500),
	Content NVARCHAR(MAX),
	EventType NVARCHAR(200),
	IsManual BIT,
	IsReassign BIT,
	IsSystem BIT,
	ReassignTo uniqueidentifier,
	ProcessCode NVARCHAR(200),
	ProcessDescription NVARCHAR(200),
	ProcItemId uniqueidentifier,
	LastAccessTime NVARCHAR(100),
	RequiredHours Decimal,
	LoggedHours Decimal,
	MissingHours Decimal,
	TriggeredBy uniqueidentifier,
	InsertDate DateTime,
	UserId uniqueidentifier
	PRIMARY KEY (ID)
)
END;