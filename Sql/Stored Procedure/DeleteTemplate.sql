IF OBJECT_ID('[ed].[DeleteTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[DeleteTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[DeleteTemplate] 
	@Id INT
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [ed].[NotificationTemplate]
		WHERE Id = @Id;
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to delete template', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO