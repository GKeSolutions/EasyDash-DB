IF OBJECT_ID('[ed].[GeNotificationTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GeNotificationTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GeNotificationTemplate]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT
		ID
		, IsActive
		, IsDefault
		, [Description]
		, [Type]
		, [Priority]
		, [Role]
		, Process
		, TemplateSubject
		, TemplateBody
	FROM ed.NotificationTemplate;
END