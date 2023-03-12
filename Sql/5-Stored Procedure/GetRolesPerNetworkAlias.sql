IF OBJECT_ID('[ed].[GetRolesPerNetworkAlias]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetRolesPerNetworkAlias] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetRolesPerNetworkAlias]
	@NetworkAlias NVARCHAR(64) = NULL
    AS
    BEGIN
        SET NOCOUNT ON;
		SELECT Distinct
			role.NxRoleID RoleId, 
			baseUser.BaseUserName RoleName
		From nxfwkuser fwkUser 
		Join NxRoleUser roleUser on roleUser.UserID = fwkUser.NxFWKUserID
		Join NxRole role on role.NxRoleID = roleUser.RoleID
		Join NxBaseUser baseUser on baseuser.NxBaseUserID = role.NxRoleId
		Where fwkUser.NetworkAlias = @NetworkAlias
END