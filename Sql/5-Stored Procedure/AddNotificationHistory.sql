IF OBJECT_ID('[ed].[AddNotificationHistory]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[AddNotificationHistory] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[AddNotificationHistory] 
	@To NVARCHAR(MAX)
	, @Cc NVARCHAR(MAX)
	, @Subject NVARCHAR(500)
	, @Content NVARCHAR(MAX)
	, @EventType NVARCHAR(200)
	, @IsManual BIT = NULL
	, @IsReassign BIT = NULL
	, @IsSystem BIT = NULL
	, @ReassignTo uniqueidentifier = NULL
	, @ProcessCode NVARCHAR(200) = NULL
	, @ProcessDescription NVARCHAR(200) = NULL
	, @LastAccessTime NVARCHAR(200) = NULL
	, @ProcItemId uniqueidentifier = NULL
	, @LoggedHours Decimal = NULL
	, @MissingHours Decimal = NULL
	, @RequiredHours Decimal = NULL
	, @TriggeredBy NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
INSERT INTO [ed].[NotificationHistory]
           ([To]
           ,[Cc]
           ,[Subject]
           ,[Content]
           ,[EventType]
           ,[IsManual]
           ,[IsReassign]
           ,[IsSystem]
           ,[ReassignTo]
		   ,[ProcessCode]
           ,[ProcessDescription]
           ,[ProcItemId]
           ,[LastAccessTime]
           ,[RequiredHours]
           ,[LoggedHours]
           ,[MissingHours]
           ,[TriggeredBy]
           ,[InsertDate])
		 VALUES
			   (@To
			   , @Cc
			   , @Subject
			   , @Content
			   , @EventType
			   , @IsManual
			   , @IsReassign
			   , @IsSystem
			   , @ReassignTo
			   , @ProcessCode
			   , @ProcessDescription
			   , @ProcItemId
			   , @LastAccessTime
			   , @RequiredHours
			   , @LoggedHours
			   , @MissingHours
			   , @TriggeredBy
			   , Current_TimeStamp);
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new template', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO