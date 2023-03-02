IF OBJECT_ID('[ed].[GetProcessInfoByProcId]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetProcessInfoByProcId] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetProcessInfoByProcId] @ProcessId uniqueidentifier
    AS
    BEGIN
        SET NOCOUNT ON;
        SELECT
            bu.BaseUserName UserName,
            bu.NxBaseUserID UserId,
            ISNULL(msg.Msg, pit.[Name]) ProcessCaption,
            pis.LastAccessTime LastUpdated,
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
            AND EndDateTime IS NULL
			and pis.ProcItemID = @ProcessId
END

