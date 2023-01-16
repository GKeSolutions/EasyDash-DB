param (
    [string]
    $ConnectionString = $(throw "-ConnectionString is required."),
    [string]
    $SQLFilePath = $(throw "-SQLFilePath is required."),
    [string]
    $SQLFolderSuffix = $(throw "-SQLFolderSuffix is required."),
    [string]
    $SQLExcludePattern = $(throw "-SQLExcludePattern is required.")
)
<#
	./Run-SQL.ps1 -ConnectionString "Data Source=localhost,1433; Initial Catalog=TE_3E_SANDBOX29; Integrated Security=True" -SQLFilePath "C:\Develop\EasyDash\EasyDash-DB\Sql\" -SQLFolderSuffix "" -SQLExcludePattern "*RunOnce*"
#>
$FullSQLFolderPath = "$SQLFilePath\$SQLFolderSuffix";

Get-ChildItem $FullSQLFolderPath -Recurse -Filter *.sql -Exclude $SQLExcludePattern | 

Foreach-Object {
    $scriptfullpath = $_.FullName
    $scriptname = $_.Name

    Try
    {
        Invoke-Sqlcmd -ConnectionString $ConnectionString -InputFile $scriptfullpath -ErrorAction Stop
        Write-Host "[Completed] $scriptname"
    }
    Catch
    {
        $ErrorMessage = $_.Exception.Message
        Write-Error "[Error running $scriptname]: $ErrorMessage"
        Exit 1
    }
}