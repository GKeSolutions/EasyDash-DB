IF OBJECT_ID('[ed].[UpdateTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[UpdateTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[UpdateTemplate] 
	@Id INT
	, @IsActive BIT
	, @Description NVARCHAR(100)
	, @Type INT
	, @Priority INT
	, @Role uniqueidentifier
	, @Process NVARCHAR(100)
	, @TemplateSubject NVARCHAR(500)
	, @TemplateBody NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		Update [ed].[NotificationTemplate]
		SET [IsActive]=@IsActive
			,[Description]=@Description
			,[Type]=@Type
			,[Priority]=@Priority
			,[Role]=@Role
			,[Process]=@Process
			,[TemplateSubject]=@TemplateSubject
			,[TemplateBody]=@TemplateBody
		WHERE Id = @Id;
		SELECT * FROM [ed].[NotificationTemplate] WHERE ID = @Id
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to update template', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO