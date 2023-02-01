IF OBJECT_ID('[ed].[UpdateScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[UpdateScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[UpdateScheduler] 
	@Id INT
	, @CronExpression NVARCHAR(200)
	, @Description NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		Update [ed].[Scheduler]
		SET CronExpression=@CronExpression
			,Description=@Description
		WHERE Id = @Id;
		SELECT * FROM [ed].[Scheduler] WHERE ID = @Id;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to update scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO