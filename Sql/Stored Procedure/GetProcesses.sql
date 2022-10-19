ALTER PROCEDURE [dbo].[GetProcesses] 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		bu.BaseUserName UserName, 
		bu.NxBaseUserID UserId, 
		pis.CreateDateTime LastUpdated, 
		pis.ProcItemID ProcessItemId, 
		pi.ProcCode ProcessCode, 
		pi.Description ProcessDescription,
		u.EmailAddr UserEmail
	FROM NxFWKProcessItemStep pis
		JOIN NxBaseUser bu ON bu.NxBaseUserID = pis.CurrentUserId
		JOIN NxFWKUser u ON u.NxFWKUserID = bu.NxBaseUserID
		Join NxFWKProcessItem pi ON pi.ProcItemID = pis.ProcItemID
	WHERE EndDateTime IS NULL
END