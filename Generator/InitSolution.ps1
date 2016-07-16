#
# InitSolution.ps1
#
# InitSolution.ps1 copies the empty solution to the jsnlogSimpleWorkingDemos project,
# and updates the files of the projects inside the solution with 
# logging package specific code, etc.
#
# Before the resulting solution is ready to be used,
# 1) Open the solution in Visual Studio;
# 2) run the InstallPackages.ps1 script inside the Package Manager Console, to install the required Nuget packages. 
#
# Note that these scripts cannot be combined. Trying to update the project files from within the running
# Visual Studio causes confusion.

. "$PSScriptRoot\helpers\FileHelpers.ps1"
. "$PSScriptRoot\helpers\NugetHelpers.ps1"
. "$PSScriptRoot\helpers\Sites.ps1"

CopyEmptySolution

foreach ($site in $Sites)
{
	$features = @("Base")
	if ($site.loggingPackage)
	{
		$features += $site.loggingPackage
	}

	$features += $site.features

	foreach ($feature in $features)
	{
		ApplyFeatureToProject $site.projectName $feature
	}

	ReplaceProjectMarkers $site.projectName
	RemoveMarkersFromProject $site.projectName
}

cmd /c "devenv $SolutionPath"
