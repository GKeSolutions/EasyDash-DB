IF OBJECT_ID('[ed].[DeleteScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[DeleteScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[DeleteScheduler] 
	@Id INT
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [ed].[NotificationScheduler]
		WHERE Id = @Id;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to delete Scheduler', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO