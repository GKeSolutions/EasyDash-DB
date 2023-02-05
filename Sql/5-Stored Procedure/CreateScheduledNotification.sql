IF OBJECT_ID('[ed].[CreateScheduledNotification]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[CreateScheduledNotification] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[CreateScheduledNotification] 
	@IsActive BIT
	, @NotificationTemplate INT
	, @Scheduler INT
	, @NotifyAfterDays INT
	, @ReassignTo uniqueidentifier
	, @CcContact uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO [ed].[ScheduledNotification]
				([IsActive]
				,[NotificationTemplate]
				,[Scheduler]
				,[NotifyAfterDays]
				,[ReassignTo]
				,[CcContact])
		 VALUES
			   (@IsActive
			   , @NotificationTemplate
			   , @Scheduler
			   , @NotifyAfterDays
			   , @ReassignTo
			   , @CcContact)
		DECLARE @NewId INT = SCOPE_IDENTITY();
		SELECT * FROM [ed].[ScheduledNotification] WHERE ID = @NewId;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new ScheduledNotification', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO