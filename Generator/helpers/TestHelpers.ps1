#
# TestHelpers.ps1
#

. "$PSScriptRoot\FileHelpers.ps1"
. "$PSScriptRoot\HttpHelpers.ps1"
. "$PSScriptRoot\BuildHelpers.ps1"
. "$PSScriptRoot\Sites.ps1"

Function TestSite($site)
{
	if ((-not $site.expectedStrings) -or ($site.expectedStrings.Length -eq 0)) { Return }

	$logFilePath = ProjectFilePath $site.projectName "Logs/log.txt"
	$logFileContents = [IO.File]::ReadAllText($logFilePath)

	Write-Host "----------- $site.projectName"

	foreach ($expectedString in $site.expectedStrings)
	{
		if (-not ($logFileContents -like "*$expectedString*"))
		{
			Write-Host "$expectedString not found in $logFilePath"
		}
	}
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
		OpenUrlInBrowser $port
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
