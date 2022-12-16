IF OBJECT_ID('[ed].[UpdateScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[UpdateScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[UpdateScheduler] 
	@Id INT
	, @IsActive BIT
	, @NotificationTemplate INT
	, @Schedule NVARCHAR(500)
	, @NotifyAfterDays INT
	, @ReassignTo uniqueidentifier
	, @CcContact uniqueidentifier
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		Update [ed].[NotificationScheduler]
		SET [IsActive]=@IsActive
			,[NotificationTemplate]=@NotificationTemplate
			,[Schedule]=@Schedule
			,[NotifyAfterDays]=@NotifyAfterDays
			,[ReassignTo]=@ReassignTo
			,[CcContact]=@CcContact
		WHERE Id = @Id;
		SELECT * FROM [ed].[NotificationScheduler] WHERE ID = @Id
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to update scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO