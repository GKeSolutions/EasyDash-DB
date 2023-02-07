IF OBJECT_ID('[ed].[GetCcContactEmailAddress]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetCcContactEmailAddress] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GetCcContactEmailAddress]
	@ccContact uniqueidentifier
AS
BEGIN
	SELECT n.EmailAddr From NxFWKUser n
	WHERE n.NxFWKUserID=@ccContact
END
GO
