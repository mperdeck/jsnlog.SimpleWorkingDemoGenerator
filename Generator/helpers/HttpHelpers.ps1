#
# HttpHelpers.ps1
#

# $jobName - name for the job that runs the server
# $sourcePath - directory where the site's web.config is located
# $port - url will be localhost:<port>
Function StartServer([string] $jobName, [bool] $isCore, [string] $sourcePath, [int] $port)
{
	Write-Host "Starting server $jobName, port $port, source: $sourcePath"

	if ($isCore)
	{
		$launchSettingsPath = $sourcePath + "\\Properties\\launchSettings.json"
		$launchSettingsContent = [System.IO.File]::ReadAllText($launchSettingsPath)
		$launchSettingsContent = $launchSettingsContent.Replace("__PORT__", $port.ToString())
		[System.IO.File]::WriteAllText($launchSettingsPath, $launchSettingsContent)
	
		Start-Job -Name $jobName -Arg $sourcePath,$port -ScriptBlock {
			param ($sourcePath, $port)
			& cd $sourcePath
			& dotnet run
		}
	}
	else
	{
		Start-Job -Name $jobName -Arg $sourcePath,$port -ScriptBlock {
			param ($sourcePath, $port)
			& 'C:\Program Files (x86)\IIS Express\iisexpress.exe' /port:$port /path:$sourcePath
		}
	}
}

Function StopServer([string] $jobName)
{
    Stop-Job -Name $jobName
    Remove-Job -Name $jobName
}

# $port - GET will be sent to localhost:<port>
Function SendGetRequest([int] $port)
{
	$url = "localhost:$port"
	Invoke-WebRequest -Uri $url	-Method Get
}


# $port - GET will be sent to localhost:<port>
Function OpenLocalhostInBrowser([int] $port)
{
	$url = "http://localhost:$port"
	OpenUrlInBrowser $url
}

Function OpenUrlInBrowser([string] $url)
{
	Write-Host "opening $url"

	$webDriverPath = "$PSScriptRoot\WebDriver\WebDriver.dll"
	Add-Type -path $webDriverPath

	#initiate a driver
	$script:driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver

	#browse to a website
	$driver.Url = $url

	# Give the browser some time to load and run the JavaScript before opening another site
	Start-Sleep -s 2

	#potential error message if element hasn't been loaded yet
	$driver.Close()
	$driver.Dispose()
	$driver.Quit()
}
