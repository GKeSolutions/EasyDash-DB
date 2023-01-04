IF OBJECT_ID('[ed].[AddNotificationHistory]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[AddNotificationHistory] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[AddNotificationHistory] 
	@To NVARCHAR(MAX)
	, @Cc NVARCHAR(MAX)
	, @Subject NVARCHAR(500)
	, @Content NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
INSERT INTO [ed].[NotificationHistory]
           ([To]
           ,[Cc]
           ,[Subject]
           ,[Content]
           ,[InsertDate])
		 VALUES
			   (@To
			   , @Cc
			   , @Subject
			   , @Content
			   , Current_TimeStamp);
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new template', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO