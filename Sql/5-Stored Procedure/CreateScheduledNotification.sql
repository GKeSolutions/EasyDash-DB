IF OBJECT_ID('[ed].[CreateScheduledNotification]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[CreateScheduledNotification] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[CreateScheduledNotification] 
	@IsActive BIT
	, @NotificationTemplate INT
	, @Scheduler INT
	, @NotifyAfterDays INT
	, @ReassignTo uniqueidentifier
	, @IsCancelProcess BIT
	, @CcContact NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		Declare @EventType INT, @CronExpression NVARCHAR(200);
		SELECT @EventType = nt.[Type] FROM ed.NotificationTemplate nt WHERE Id = @NotificationTemplate;
		SELECT @CronExpression = s.CronExpression FROM ed.Scheduler s WHERE Id = @Scheduler
		INSERT INTO [ed].[ScheduledNotification]
				([IsActive]
				,[NotificationTemplate]
				,[Scheduler]
				,[NotifyAfterDays]
				,[ReassignTo]
				,[IsCancelProcess]
				,[CcContact])
		 VALUES
			   (@IsActive
			   , @NotificationTemplate
			   , @Scheduler
			   , @NotifyAfterDays
			   , @ReassignTo
			   , @IsCancelProcess
			   , @CcContact)
		DECLARE @NewId INT = SCOPE_IDENTITY();
		SELECT ID, IsActive, NotificationTemplate, Scheduler, NotifyAfterDays, ReassignTo, IsCancelProcess, CcContact, @EventType EventType, @CronExpression CronExpression FROM [ed].[ScheduledNotification] WHERE ID = @NewId;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new ScheduledNotification', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO