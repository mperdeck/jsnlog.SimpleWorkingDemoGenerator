#
# BuildHelpers.ps1
#

. "$PSScriptRoot\FileHelpers.ps1"
. "$PSScriptRoot\HttpHelpers.ps1"
. "$PSScriptRoot\BuildHelpers.ps1"
. "$PSScriptRoot\Sites.ps1"

Function TestSite($site)
{
	$logFilePath = ProjectFilePath $site.projectName "Logs/log.txt"
	$logFileContents = [IO.File]::ReadAllText($logFilePath)





}

# Runs integration tests against the created sites
Function RunTests()
{
	BuildSolution $SolutionPath

	$port = 9000
	foreach ($site in $Sites)
	{
		StartServer $site.projectName (ProjectDirPath $site.projectName) $port
		$port++
	}

	Start-Sleep -s 5

	$port = 9000
	foreach ($site in $Sites)
	{
		SendGetRequest $port
		$port++
	}

	Start-Sleep -s 5

	foreach ($site in $Sites)
	{
		TestSite $site
	}

	foreach ($site in $Sites)
	{
		StopServer $site.projectName
	}
}
