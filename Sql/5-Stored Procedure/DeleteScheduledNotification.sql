IF OBJECT_ID('[ed].[DeleteScheduledNotification]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[DeleteScheduledNotification] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[DeleteScheduledNotification] 
	@Id INT
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [ed].[ScheduledNotification]
		WHERE Id = @Id;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to delete Scheduled Notification', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO