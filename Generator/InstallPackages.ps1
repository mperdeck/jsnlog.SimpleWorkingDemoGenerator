
. "$PSScriptRoot\helpers\FileHelpers.ps1"
. "$PSScriptRoot\helpers\NugetHelpers.ps1"
. "$PSScriptRoot\helpers\Sites.ps1"

foreach ($site in $Sites)
{
	InstallLoggingRelatedPackages $site.projectName $site.loggingPackage

	foreach ($package in $site.packages)
	{
		InstallPackage $projectName $package
	}
}


