IF OBJECT_ID(N'[ed].[GetUserRoles]',N'IF') IS NULL
	EXEC(N'CREATE FUNCTION [ed].[GetUserRoles]() RETURNS TABLE WITH ENCRYPTION AS RETURN (SELECT 1 x);');
GO
ALTER FUNCTION [ed].[GetUserRoles](@userId uniqueidentifier)
RETURNS TABLE
WITH ENCRYPTION AS 
RETURN (
	SELECT 
		r.NxRoleID RoleId
		, r.Description RoleName
	FROM nxbaseuser u
		INNER JOIN dbo.NxRoleUser ru ON ru.UserID = u.NxBaseUserID
		INNER JOIN dbo.NxRole r ON r.NxRoleID = ru.RoleID
	WHERE u.NxBaseUserID=@userId
);
GO