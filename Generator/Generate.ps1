#
# Generate.ps1
#

. "$PSScriptRoot\helpers\FileHelpers.ps1"

# ------------------------------------------
# JSNLogDemo_Log4Net

CopyMainFiles "JSNLogDemo_Log4Net" "Log4Net"
Install-Package log4net [-ProjectName <string>] [[-Source] <string>] 
Install-Package JSNLog.Log4Net





