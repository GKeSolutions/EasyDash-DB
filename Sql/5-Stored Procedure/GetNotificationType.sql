IF OBJECT_ID('[ed].[GeNotificationType]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GeNotificationType] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GeNotificationType]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT Id, Code, [Description] FROM ed.NotificationType;
END