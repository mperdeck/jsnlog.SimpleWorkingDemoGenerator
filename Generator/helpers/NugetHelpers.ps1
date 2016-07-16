#
# NugetHelpers.ps1
#

Function InstallPackage([string] $projectName, [string] $packageId)
{
	if ($packageId -match "jsnlog")
	{
		Install-Package $packageId -ProjectName $projectName -Source "C:\Dev\@NuGet\GeneratedPackages"
	}
	else
	{
		Install-Package $packageId -ProjectName $projectName
	}
}

# Installs the logging package and the JSNLog adapter package for the logging package
Function InstallLoggingRelatedPackages([string] $projectName, [string] $logPackage)
{
	InstallPackage $projectName $logPackage
	InstallPackage $projectName "JSNLog.$logPackage"
}






