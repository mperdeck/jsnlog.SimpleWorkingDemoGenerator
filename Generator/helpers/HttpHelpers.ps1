#
# HttpHelpers.ps1
#

# $jobName - name for the job that runs the server
# $sourcePath - directory where the site's web.config is located
# $port - url will be localhost:<port>
Function StartServer([string] $jobName, [string] $sourcePath, [int] $port)
{
    Start-Job -Name $jobName -Arg $sourcePath -ScriptBlock {
        param ($sourcePath)
        & 'C:\Program Files (x86)\IIS Express\iisexpress.exe' /port:$port /path:$sourcePath
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

