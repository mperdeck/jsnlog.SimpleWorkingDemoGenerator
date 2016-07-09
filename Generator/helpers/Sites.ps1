#
# Sites.ps1
#

$sites = @(
	[pscustomobject]@{projectName="JSNLogDemo_Serilog"; features=@("Base", "Serilog") },
	[pscustomobject]@{projectName="JSNLogDemo_Elmah"; features=@("Base", "Elmah") }
)
