#
# NugetHelpers.ps1
#

Function InstallPackage([string] $projectName, [string] $packageId, [string] $source)
{
	if ($source)
	{
		Install-Package $packageId -ProjectName $projectName -Source $source
	}
	else
	{
		Install-Package $packageId -ProjectName $projectName
	}
}

# Installs the logging package and the JSNLog adapter package for the logging package
Function InstallMainPackage([string] $projectName, [string] $logPackage)
{
	InstallPackage $projectName $logPackage
	InstallPackage $projectName "JSNLog.$logPackage" "C:\Dev\@NuGet\GeneratedPackages"
}






