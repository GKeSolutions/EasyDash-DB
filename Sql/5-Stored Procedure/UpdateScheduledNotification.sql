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
	, @CcContact uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		Update [ed].[ScheduledNotification]
		SET [IsActive]=@IsActive
			,[NotificationTemplate]=@NotificationTemplate
			,[Scheduler]=@Scheduler
			,[NotifyAfterDays]=@NotifyAfterDays
			,[ReassignTo]=@ReassignTo
			,[CcContact]=@CcContact
		WHERE Id = @Id;
		SELECT * FROM [ed].[ScheduledNotification] WHERE ID = @Id;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to update scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO