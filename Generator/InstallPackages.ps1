
. "$PSScriptRoot\helpers\TestHelpers.ps1"
. "$PSScriptRoot\helpers\FileHelpers.ps1"
. "$PSScriptRoot\helpers\NugetHelpers.ps1"
. "$PSScriptRoot\helpers\Sites.ps1"
. "$PSScriptRoot\helpers\KeysHelpers.ps1"




#SendKey "+^S"

# SendKey "^+s"
#Exit









foreach ($site in $Sites)
{
	InstallLoggingRelatedPackages $site.projectName $site.loggingPackage

	foreach ($package in $site.packages)
	{
		InstallPackage $site.projectName $package
	}

	foreach ($removeRegex in $site.removeRegexes)
	{
		RemoveRegexesFromProjectWebConfig $site.projectName $removeRegex
	}
}

Start-Sleep -s 5

# Send Cntrl+Shift+S key stroke to perform Save All in Visual Studio. This saves 
# all the changes that have been made by installing the packages. See
# https://technet.microsoft.com/en-us/library/ff731008.aspx
# If you don't do this, any build will fail.

SendKey "+^S"

Start-Sleep -s 5

RunTests


