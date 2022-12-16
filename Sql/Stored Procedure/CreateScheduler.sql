IF OBJECT_ID('[ed].[CreateScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[CreateScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[CreateScheduler] 
	@IsActive BIT
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
		INSERT INTO [ed].[NotificationScheduler]
				([IsActive]
				,[NotificationTemplate]
				,[Schedule]
				,[NotifyAfterDays]
				,[ReassignTo]
				,[CcContact])
		 VALUES
			   (@IsActive
			   , @NotificationTemplate
			   , @Schedule
			   , @NotifyAfterDays
			   , @ReassignTo
			   , @CcContact)
		SELECT NEWID();
		DECLARE @NewId INT = SCOPE_IDENTITY();
		SELECT * FROM [ed].[NotificationTemplate] WHERE ID = @NewId
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO