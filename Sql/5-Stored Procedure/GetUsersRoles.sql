IF OBJECT_ID('[ed].[GetUsersRoles]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetUsersRoles] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [ed].[GetUsersRoles]
		@users IdListGui readonly
	AS
	BEGIN
		SELECT 
			u.nxBaseUserId UserId
			, r.NxRoleID RoleId
			, r.Description RoleName
		FROM nxbaseuser u
			INNER JOIN dbo.NxRoleUser ru ON ru.UserID = u.NxBaseUserID
			INNER JOIN dbo.NxRole r ON r.NxRoleID = ru.RoleID
			INNER JOIN @users users On users.Id = u.nxBaseUserId
		ORDER BY u.nxBaseUserId, r.Description

	END
GO
