IF OBJECT_ID('[ed].[UpdateScheduledNotification]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[UpdateScheduledNotification] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[UpdateScheduledNotification] 
	@Id INT
	, @IsActive BIT
	, @NotificationTemplate INT
	, @Scheduler NVARCHAR(500)
	, @NotifyAfterDays INT
	, @ReassignTo uniqueidentifier
	, @CcContact NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		Declare @EventType INT, @CronExpression NVARCHAR(200);
		SELECT @EventType = nt.[Type] FROM ed.NotificationTemplate nt WHERE Id = @NotificationTemplate;
		SELECT @CronExpression = s.CronExpression FROM ed.Scheduler s WHERE Id = @Scheduler
		Update [ed].[ScheduledNotification]
		SET [IsActive]=@IsActive
			,[NotificationTemplate]=@NotificationTemplate
			,[Scheduler]=@Scheduler
			,[NotifyAfterDays]=@NotifyAfterDays
			,[ReassignTo]=@ReassignTo
			,[CcContact]=@CcContact
		WHERE Id = @Id;
		SELECT ID, IsActive, NotificationTemplate, Scheduler, NotifyAfterDays, ReassignTo, CcContact, @EventType EventType, @CronExpression CronExpression FROM [ed].[ScheduledNotification] WHERE ID = @Id;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to update scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO