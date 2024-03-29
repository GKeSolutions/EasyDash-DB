IF OBJECT_ID('[ed].[GetIdleUsersPerProcess]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetIdleUsersPerProcess] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetIdleUsersPerProcess]
	@ProcessCode NVARCHAR(64) = NULL
	, @idleDays INT
    AS
    BEGIN
        SET NOCOUNT ON;
        SELECT Distinct
            bu.BaseUserName UserName,
            bu.NxBaseUserID UserId,
            ISNULL(msg.Msg, pit.[Name]) ProcessCaption,
            pis.CreateDateTime LastUpdated,
            pis.ProcItemID ProcessItemId,
            pit.ProcCode ProcessCode,
            pit.Name ProcessDescription,
            u.EmailAddr UserEmail
        FROM NxFWKProcessItemStep pis
            JOIN NxBaseUser bu ON bu.NxBaseUserID = pis.CurrentUserId
            JOIN NxFWKUser u ON u.NxFWKUserID = bu.NxBaseUserID
            JOIN NxFWKProcessItem pit ON pit.ProcItemID = pis.ProcItemID
            JOIN dbo.NxFWKAppObject Appobject ON Appobject.AppObjectCode = pit.ProcCode
            JOIN dbo.NxFWKAppObjectType ObjectType ON ObjectType.NxFWKAppObjectTypeID = Appobject.AppObjectTypeId
            LEFT OUTER JOIN dbo.nxmsg msg ON msg.MsgId = appobject.AppObjectCaptionId AND msg.LanguageIndex = 1033 -- English langauage
        WHERE ObjectType.AppObjectTypeCode = 'Process' 
			AND pit.ProcCode =   CASE WHEN @ProcessCode IS NULL THEN pit.ProcCode ELSE @ProcessCode END
            AND EndDateTime IS NULL
            AND pit.IsComplete = 0
			AND DATEDIFF(Minute, pis.CreateDateTime, GETDATE()) > @idleDays * 60  * 24 -- Convert the number of idle days to minutes
END