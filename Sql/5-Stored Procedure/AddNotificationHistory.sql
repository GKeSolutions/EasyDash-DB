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