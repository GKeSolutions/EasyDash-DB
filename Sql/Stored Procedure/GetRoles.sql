IF OBJECT_ID('[ed].[GetRoles]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetRoles] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [dbo].[GetRoles] 
	AS
	BEGIN
		SELECT NxRoleId RoleId, Description RoleName
		FROM NxRole
		ORDER BY Description
END