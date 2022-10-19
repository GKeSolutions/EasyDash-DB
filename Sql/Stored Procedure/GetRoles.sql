ALTER PROCEDURE [dbo].[GetRoles] 
AS
BEGIN
	SELECT NxRoleId RoleId, Description RoleName
	FROM NxRole
	ORDER BY Description
END