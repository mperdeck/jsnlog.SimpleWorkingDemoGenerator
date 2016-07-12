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

	$projectName = $site.projectName
	$logDirPath = ProjectFilePath $projectName "Logs"

	# Elmah writes each log entry to a separate file, while other packages write the log entries to one file.
	# So just get all log content (from whatever file is in the Logs dir).
	$logFilesContents = ContentAllFilesInDir $logDirPath

	Write-Host "----------- $projectName"

	foreach ($expectedString in $site.expectedStrings)
	{
		if (-not ($logFilesContents -like "*$expectedString*"))
		{
			Write-Host "`"$expectedString`" not found in $logDirPath"
		}
	}
}

# Runs integration tests against the created sites
Function RunTests()
{
	BuildSolution $ProjectsRootDir

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

	# #############################
	# CORS Site specific setup

	#StopServer "JSNLogDemo_Log4Net_CORS"
	#StartServer "JSNLogDemo_Log4Net_CORS" (ProjectDirPath "JSNLogDemo_Log4Net_CORS") $port

	# Make sure that corslocalhost.local and apicorslocalhost.local have been set up in IIS,
	# and point at the JSNLogDemo_Log4Net_CORS project directory.
	# They also have to be added to the hosts file.

	OpenUrlInBrowser "http://corslocalhost.local"

	# #############################

	# Serilog keeps the log file locked for a while
	Start-Sleep -s 10

	foreach ($site in $Sites)
	{
		TestSite $site
	}

	foreach ($site in $Sites)
	{
		StopServer $site.projectName
	}
}
