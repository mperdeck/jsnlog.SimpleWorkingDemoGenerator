#
# Sites.ps1
#

$sites = @(
	[pscustomobject]@{projectName="JSNLogDemo_Log4Net"; features=@("Base", "Log4Net") },
	[pscustomobject]@{projectName="JSNLogDemo_Elmah"; features=@("Base", "Elmah") }
)
