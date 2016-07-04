#
# Generate.ps1
#

. "$PSScriptRoot\helpers\FileHelpers.ps1"
. "$PSScriptRoot\helpers\NugetHelpers.ps1"

# ------------------------------------------

# Copies in the required files, and installs the logging package and the JSNLog adapter package for the logging package
Function BuildSite([string] $projectName, [string] $logPackage)
{
	CopyMainFiles $projectName $logPackage
	InstallMainPackage $projectName $logPackage
}

# ------------------------------------------
# JSNLogDemo_Log4Net

BuildSite "JSNLogDemo_Log4Net" "Log4Net"









