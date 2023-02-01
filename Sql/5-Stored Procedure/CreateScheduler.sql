IF OBJECT_ID('[ed].[CreateScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[CreateScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[CreateScheduler] 
	@CronExpression NVARCHAR(200)
	, @Description NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO [ed].[Scheduler]
				([CronExpression]
				,[Description])
		 VALUES
			   (@CronExpression
			   , @Description)
		DECLARE @NewId INT = SCOPE_IDENTITY();
		SELECT * FROM [ed].[Scheduler] WHERE ID = @NewId;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO